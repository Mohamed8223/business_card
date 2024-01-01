import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../notifications/notifications.dart';
import '../../profile/profile.dart';
import '../posts.dart';

class CommentsNotifier extends StateNotifier<CommentModelState> {
  CommentsNotifier(this._ref) : super(CommentModelState.init());
  final Ref _ref;
  getPostComments(String postId) async {
    try {
      final commentsList =
          await _ref.read(commentsRepoProvider).getComments(postId);
      state = state.copyWith(comments: commentsList, isLoading: false);
    } catch (e) {
      state = CommentModelState(
          comments: [], error: e.toString(), isLoading: false);
    }
  }

  addComment(String postId, CommentModel commentModel, final UserModel postUser,
      final PostsHost postsHost) async {
    try {
      final relevantPostsProvider = postsHost == PostsHost.home
          ? homePostsProvider
          : profilePostsProvider;

      _ref
          .read(commentsRepoProvider)
          .newComment(postId, commentModel, state.comments.length);
      state = state.copyWith(comments: [commentModel, ...state.comments]);
      _ref
          .read(relevantPostsProvider.notifier)
          .updateCommentsCount(postId, state.comments.length);
      final notificationRepo = _ref.read(notificationsRepoProvider);
      final notification = NotificationModel(
        title: 'تم اضافة تعليق جديد',
        body: 'تم التعليق على منشورك بواسطة ${commentModel.user.fullnameAr}',
        type: 'comment',
        createdAt: DateTime.now(),
        senderId: commentModel.user.id,
        senderAvatar: commentModel.user.imageUrl,
        recieverId: postUser.id,
      );
      await Future.wait([
        notificationRepo.sendNotification(
          sendToToken: postUser.fcmToken ?? '',
          notification: notification,
        ),
        notificationRepo.storeNotification(notification: notification)
      ]);
    } catch (e) {
      state = CommentModelState(comments: state.comments, isLoading: false);
    }
  }
}

final commentsProvider =
    StateNotifierProvider.autoDispose<CommentsNotifier, CommentModelState>(
        (ref) {
  return CommentsNotifier(ref);
});
