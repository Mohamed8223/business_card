import 'package:clinigram_app/features/profile/profile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/core.dart';
import '../posts.dart';

class PostsNotifier extends StateNotifier<(List<PostModel>, bool)> {
  PostsNotifier(this._ref, this.postsHost) : super(([], false));

  final Ref _ref;
  final PostsHost postsHost;

  bool _isLoading = false;

  void getHomePosts({bool showLoading = true, int pageSize = 4}) async {
    if (postsHost == PostsHost.profile) {
      throw Exception('getHomePosts called from profile');
    }

    if (_isLoading) return;
    _isLoading = true;
    try {
      if (showLoading) {
        _ref.read(requestResponseProvider.notifier).state =
            RequestResponseModel.loading();
      }
      final posts =
          await _ref.read(postsRepoProvider).getPosts(pageSize: pageSize);
      state = ([...state.$1, ...posts], posts.length < pageSize);
    } catch (e) {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.error(message: e.toString());
    } finally {
      if (showLoading) {
        _ref.read(requestResponseProvider.notifier).state =
            RequestResponseModel.loading(loading: false);
      }
      _isLoading = false;
    }
  }

  void getUserPosts(String userId, bool isInitialLoad,
      {int pageSize = 4}) async {
    if (postsHost == PostsHost.home) {
      throw Exception('getUserPosts called from home');
    }

    try {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.loading(loadingType: LoadingTypes.inline);
      final posts = await _ref
          .read(postsRepoProvider)
          .getPosts(userId: userId, pageSize: pageSize);

      if (isInitialLoad) {
        state = ([...posts], posts.length < pageSize);
      } else {
        state = ([...state.$1, ...posts], posts.length < pageSize);
      }
    } catch (e) {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.error(message: e.toString());
    } finally {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.loading(
              loadingType: LoadingTypes.inline, loading: false);
    }
  }

  void updateCommentsCount(String postId, int count) {
    state = (
      [
        for (final post in state.$1)
          if (post.id == postId) post.copyWith(commentsCount: count) else post
      ],
      state.$2
    );
  }

  void like(
    String postId,
  ) async {
    final userModel = _ref.read(currentUserProfileProvider);
    state = (
      [
        for (final post in state.$1)
          if (post.id == postId)
            post.copyWith(likes: [...post.likes, userModel])
          else
            post
      ],
      state.$2
    );
    await _ref.read(postsRepoProvider).likePost(postId, userModel);
  }

  void unlike(
    String postId,
  ) {
    final userModel = _ref.read(currentUserProfileProvider);
    state = (
      [
        for (final post in state.$1)
          if (post.id == postId)
            post.copyWith(
                likes: [...post.likes.where((user) => user.id != userModel.id)])
          else
            post
      ],
      state.$2
    );
    _ref.read(postsRepoProvider).unlikePost(postId, userModel);
  }

  bool isLiked(List<UserModel> likers) {
    final userModel = _ref.read(currentUserProfileProvider);
    if (likers.contains(userModel)) return true;
    return false;
  }
}

enum PostsHost {
  home,
  profile,
  search,
}

final homePostsProvider =
    StateNotifierProvider.autoDispose<PostsNotifier, (List<PostModel>, bool)>(
        (ref) {
  return PostsNotifier(ref, PostsHost.home);
});

final profilePostsProvider =
    StateNotifierProvider.autoDispose<PostsNotifier, (List<PostModel>, bool)>(
        (ref) {
  return PostsNotifier(ref, PostsHost.profile);
});

final searchPostsProvider =
    StateNotifierProvider.autoDispose<PostsNotifier, (List<PostModel>, bool)>(
        (ref) {
  return PostsNotifier(ref, PostsHost.search);
});
