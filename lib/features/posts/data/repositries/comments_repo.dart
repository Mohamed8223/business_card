import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/core.dart';
import '../../posts.dart';

class CommentsRepo {
  final _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<CommentModel>> getComments(String postId) async {
    final List<CommentModel> commentsList = [];
    final commentsData = await _firebaseFirestore
        .collection(postsCollection)
        .doc(postId)
        .collection(commentsCollection)
        .orderBy('created_at', descending: true)
        .get();
    for (var comment in commentsData.docs) {
      DocumentReference userRef = comment['user'];
      DocumentSnapshot userSnapshot = await userRef.get();
      final commentMap = comment.data();
      commentMap.addAll({'id': comment.id});
      commentMap.update('user', (value) => userSnapshot.data());
      final commentModel = CommentModel.fromJson(commentMap);
      commentsList.add(commentModel);
    }

    return commentsList;
  }

  Future newComment(
      String postId, CommentModel commentModel, int commentsCount) async {
    final userRef = _firebaseFirestore
        .collection(usersCollection)
        .doc(commentModel.user.id);
    await _firebaseFirestore
        .collection(postsCollection)
        .doc(postId)
        .collection(commentsCollection)
        .add(commentModel.toDocument(userRef));
    await _firebaseFirestore
        .collection(postsCollection)
        .doc(postId)
        .update({'comments_count': commentsCount + 1});
  }
}

final commentsRepoProvider = Provider<CommentsRepo>((ref) {
  return CommentsRepo();
});
