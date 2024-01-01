import 'dart:developer';

import 'package:clinigram_app/features/consultations/consultations.dart';
import 'package:clinigram_app/features/profile/profile.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/core.dart';
import '../../notifications/notifications.dart';

class ConsultationNotifier extends StateNotifier<List<ConsultationModel>> {
  ConsultationNotifier(
    this._ref,
  ) : super([]) {
    getConsultation();
  }
  final Ref _ref;
  getConsultation() async {
    try {
      await Future.delayed(Duration.zero);
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.loading();
      final userModel = _ref.read(currentUserProfileProvider);
      state = await _ref
          .read(consultationRepoProvider)
          .getAllConsultation(userModel);
    } catch (e) {
      log(e.toString());
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.error(message: e.toString());
    } finally {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.loading(loading: false);
    }
  }

  updateConsultationDoctor(String consultationId, UserModel doctor) async {
    try {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.loading();
      await _ref
          .read(consultationRepoProvider)
          .assignDoctorToConsultation(consultationId, doctor);
      try {
        final admin = _ref.watch(currentUserProfileProvider);
        final notificationRepo = _ref.read(notificationsRepoProvider);
        final notification = NotificationModel(
          title: 'تم اسنادك الى استشارة',
          body: 'تم اسنادك الى استشارة بواسطة المدير ${admin.fullnameAr}',
          type: 'assign_consultation',
          createdAt: DateTime.now(),
          senderId: admin.id,
          senderAvatar: admin.imageUrl,
          recieverId: doctor.id,
        );
        await Future.wait([
          notificationRepo.sendNotification(
            sendToToken: doctor.fcmToken ?? '',
            notification: notification,
          ),
          notificationRepo.storeNotification(notification: notification)
        ]);
      } catch (e) {
        debugPrint('error:$e');
      }
      state = [
        for (final item in state)
          if (item.id == consultationId) item.copyWith(doctor: doctor) else item
      ];
    } catch (e) {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.error(message: e.toString());
    } finally {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.loading(loading: false);
    }
  }
}

final consultationProvider = StateNotifierProvider.autoDispose<
    ConsultationNotifier, List<ConsultationModel>>((ref) {
  return ConsultationNotifier(ref);
});
