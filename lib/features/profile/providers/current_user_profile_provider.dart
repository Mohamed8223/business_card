import 'dart:io';

import 'package:clinigram_app/features/profile/profile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/core.dart';

class CurrentUserProfileNotifier extends StateNotifier<UserModel> {
  CurrentUserProfileNotifier(this._ref) : super(UserModel.init());
  final Ref _ref;

  Future<void> getUserData() async {
    try {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.loading();
      final userModel =
          await _ref.read(profileRepoProvider).getUserById(state.id);
      _ref.read(followersFollowingsProvider.notifier).state =
          FollowersFollowingsModel(
              followers: userModel!.followers,
              followings: userModel.followings);
      state = userModel;
    } catch (e) {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.error(message: e.toString());
    } finally {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.loading(loading: false);
    }
  }

  updateUserProfile(UserModel userModel) async {
    try {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.loading();
      if (userModel.imageUrl.isNotEmpty &&
          !isFirebaseStorageUrlRegex(userModel.imageUrl)) {
        final uploadedImageUrl = await uploadFileToFirebase(
            File(userModel.imageUrl), usersProfileImagesCollection);
        userModel = userModel.copyWith(imageUrl: uploadedImageUrl);
      }
      await _ref.read(profileRepoProvider).updateProfile(userModel);
      state = userModel;
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
}

final currentUserProfileProvider =
    StateNotifierProvider<CurrentUserProfileNotifier, UserModel>((ref) {
  return CurrentUserProfileNotifier(ref);
});
