import 'dart:io' show File;

import 'package:clinigram_app/features/consultations/consultations.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/core.dart';
import '../../notifications/notifications.dart';
import '../../profile/profile.dart';

class CreateConsultationProvider {
  CreateConsultationProvider(this._ref);
  final Ref _ref;
  createNewConsultation(String consultationDescription, File? attatchment,
      AttatchmentType attatchmentType) async {
    try {
      final userModel = _ref.read(currentUserProfileProvider);
      ConsultationModel consultationModel = ConsultationModel(
        id: '',
        description: consultationDescription,
        patient: userModel,
        attatchmentType: attatchmentType,
        createdAt: DateTime.now(),
      );
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.loading();
      if (attatchment != null) {
        final attatchmentUrl = await uploadPatientAttatchment(attatchment);
        consultationModel = consultationModel.copyWith(fileUrl: attatchmentUrl);
      }
      _ref.read(consultationRepoProvider).newConsultation(consultationModel);
      try {
        final notificationRepo = _ref.read(notificationsRepoProvider);
        final admin = await _ref.watch(adminProvider.future);
        if (admin != null) {
          final notification = NotificationModel(
            title: 'تم اضافة استشارة جديدة',
            body:
                'تم اضافة استشارة بواسطة ${consultationModel.patient.fullnameAr}',
            type: 'consultation',
            createdAt: DateTime.now(),
            senderId: consultationModel.patient.id,
            senderAvatar: consultationModel.patient.imageUrl,
            recieverId: admin.id,
          );
          await Future.wait([
            notificationRepo.sendNotification(
              sendToToken: admin.fcmToken ?? '',
              notification: notification,
            ),
            notificationRepo.storeNotification(notification: notification)
          ]);
        }
      } catch (e) {
        debugPrint('error:$e');
      }
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.sucess();
    } catch (e) {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.error(message: e.toString());
    } finally {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.loading(loading: false);
    }
  }

  Future<String> uploadPatientAttatchment(File file) async {
    String fileUrl =
        await uploadFileToFirebase(file, consultationAttatchmentsCollection);
    return fileUrl;
  }
}

final createConsultationProvider = Provider<CreateConsultationProvider>((ref) {
  return CreateConsultationProvider(ref);
});
