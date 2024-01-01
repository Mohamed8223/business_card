import 'dart:io';

import 'package:clinigram_app/features/auth/providers/register_user_provider.dart';
import 'package:clinigram_app/features/doctors/doctors.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/core.dart';
import '../../profile/profile.dart';

class PreRegDoctorsManageNotifier
    extends StateNotifier<AsyncValue<List<UserModel>>> {
  PreRegDoctorsManageNotifier(this._ref) : super(const AsyncData([]));

  final Ref _ref;

  getAllPreRegDoctors() async {
    try {
      state = const AsyncLoading();
      final doctorsList =
          await _ref.read(doctorsRepoProvider).getPreRegisterDoctors();
      state = AsyncData(doctorsList);
    } catch (e) {
      debugPrint(e.toString());
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<UserModel?> preRegisterDoctor(UserModel? userModel) async {
    try {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.loading();
      UserModel doctorData = userModel ?? _ref.read(registerUserProvider);
      if (doctorData.imageUrl.isNotEmpty) {
        final uploadedImageUrl = await uploadFileToFirebase(
            File(doctorData.imageUrl), usersProfileImagesCollection);
        doctorData = doctorData.copyWith(imageUrl: uploadedImageUrl);
      }
      final doctorResult =
          await _ref.read(doctorsRepoProvider).addPreRegisterDoctor(doctorData);
      state = AsyncData([...state.value!, doctorResult]);
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.sucess();

      return doctorResult;
    } catch (e) {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.error();
    }

    return null;
  }

  Future<UserModel?> editPreRegisterDoctor(UserModel? userModel) async {
    try {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.loading();
      UserModel doctorData = userModel ?? _ref.read(registerUserProvider);

      if (doctorData.imageUrl.isNotEmpty &&
          !isFirebaseStorageUrlRegex(doctorData.imageUrl)) {
        final uploadedImageUrl = await uploadFileToFirebase(
            File(doctorData.imageUrl), usersProfileImagesCollection);
        doctorData = doctorData.copyWith(imageUrl: uploadedImageUrl);
      }
      var updatedDoctor = await _ref
          .read(doctorsRepoProvider)
          .updatePreRegisterDoctor(doctorData);
      state = AsyncData([
        for (var docotr in state.value!)
          if (docotr.id != doctorData.id) docotr else doctorData
      ]);
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.sucess();

      return updatedDoctor;
    } catch (e) {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.error();
    }

    return null;
  }

  deletePreRegisterDoctor(UserModel doctorData) async {
    try {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.loading();

      await _ref
          .read(doctorsRepoProvider)
          .deletePreRegisterDoctor(doctorData.id);
      state = AsyncData([
        for (var docotr in state.value!)
          if (docotr.id != doctorData.id) docotr
      ]);
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.sucess();
    } catch (e) {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.error();
    } finally {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.loading(loading: false);
    }
  }
}

final preRegDoctorsManageProvider = StateNotifierProvider<
    PreRegDoctorsManageNotifier, AsyncValue<List<UserModel>>>((ref) {
  return PreRegDoctorsManageNotifier(ref);
});
