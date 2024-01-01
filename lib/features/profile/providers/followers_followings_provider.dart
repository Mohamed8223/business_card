import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../notifications/notifications.dart';
import '../profile.dart';

class FollowersFollowingsNotifier
    extends StateNotifier<FollowersFollowingsModel> {
  FollowersFollowingsNotifier(this._ref) : super(FollowersFollowingsModel());
  final Ref _ref;
  void follow(UserModel toBeFollowed) async {
    final follower = _ref.read(currentUserProfileProvider);
    List<UserModel> userFollowers = [follower, ...state.followers];

    state = state.copyWith(followers: userFollowers);
    await _ref.read(profileRepoProvider).follow(toBeFollowed, follower);
    try {
      final notificationRepo = _ref.read(notificationsRepoProvider);
      final notification = NotificationModel(
        title: 'تم متابعتك',
        body: '${follower.fullnameAr} قام بمتابعتك',
        type: 'following',
        createdAt: DateTime.now(),
        senderId: follower.id,
        senderAvatar: follower.imageUrl,
        recieverId: toBeFollowed.id,
      );
      await Future.wait([
        notificationRepo.sendNotification(
          sendToToken: toBeFollowed.fcmToken ?? '',
          notification: notification,
        ),
        notificationRepo.storeNotification(notification: notification)
      ]);
    } catch (e) {
      debugPrint('error:$e');
    }
  }

  void unFollow(UserModel toBeFollowed, {bool isMyProfile = false}) async {
    final unfollower = _ref.read(currentUserProfileProvider);
    if (isMyProfile) {
      List<UserModel> userFollowings = [
        for (var follower in state.followings)
          if (follower.id != toBeFollowed.id) follower
      ];

      state = state.copyWith(
        followings: userFollowings,
      );
    } else {
      List<UserModel> userFollowers = [
        for (var follower in state.followers)
          if (follower.id != unfollower.id) follower
      ];

      state = state.copyWith(
        followers: userFollowers,
      );
    }

    await _ref.read(profileRepoProvider).unFollow(toBeFollowed, unfollower);
  }

  bool isFollowed({bool isMyProfile = false, UserModel? userToBeChecked}) {
    if (isMyProfile) {
      if (state.followings.contains(userToBeChecked)) return true;
      return false;
    } else {
      final userModel = _ref.read(currentUserProfileProvider);
      if (state.followers.contains(userModel)) return true;
      return false;
    }
  }
}

final followersFollowingsProvider = StateNotifierProvider.autoDispose<
    FollowersFollowingsNotifier, FollowersFollowingsModel>((ref) {
  return FollowersFollowingsNotifier(ref);
});
