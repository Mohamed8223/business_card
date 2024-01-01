import '../profile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OtherUserProfileNotifier extends StateNotifier<UserModelState> {
  OtherUserProfileNotifier(this._ref, this._userId)
      : super(UserModelState.init()) {
    if (_userId.isNotEmpty) getUserData(_userId);
  }
  final Ref _ref;
  final String _userId;

  getUserData(String userId) async {
    try {
      final userModel =
          await _ref.read(profileRepoProvider).getUserById(userId);
      _ref.read(followersFollowingsProvider.notifier).state =
          FollowersFollowingsModel(
              followers: userModel!.followers,
              followings: userModel.followings);

      state = state.copyWith(
        user: userModel,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        user: null,
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

final otherUserProfileProvider = StateNotifierProvider.autoDispose
    .family<OtherUserProfileNotifier, UserModelState, String>((ref, userId) {
  return OtherUserProfileNotifier(ref, userId);
});
