import 'package:clinigram_app/features/profile/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/core.dart';
import '../../posts.dart';

class PostsRepo {
  PostsRepo(this._ref);
  final Ref _ref;
  final _firebaseFirestore = FirebaseFirestore.instance;
  final Map<String, QueryDocumentSnapshot<Map<String, dynamic>>> lastDocs = {};
  QueryDocumentSnapshot<Map<String, dynamic>>? globalLastDoc;

  Future newPost(PostModel postModel) async {
    final userRef = _firebaseFirestore
        .collection(usersCollection)
        .doc(postModel.userModel.id);
    await _firebaseFirestore
        .collection(postsCollection)
        .add(postModel.toDocument(userRef));
  }

  Future<List<PostModel>> getPosts({String? userId, pageSize = 10}) async {
    List<PostModel> postsList = [];

    try {
      QuerySnapshot<Map<String, dynamic>> postsData;
      final lastDoc = userId != null ? lastDocs[userId] : globalLastDoc;

      if (lastDoc != null) {
        postsData = userId == null
            ? await _firebaseFirestore
                .collection(postsCollection)
                .orderBy('created_at', descending: true)
                .startAfterDocument(lastDoc)
                .limit(pageSize)
                .get()
            : await _firebaseFirestore
                .collection(postsCollection)
                .where(
                  'user_model',
                  isEqualTo: _firebaseFirestore
                      .collection(usersCollection)
                      .doc(userId),
                )
                .orderBy('created_at', descending: true)
                .startAfterDocument(lastDoc)
                .limit(pageSize)
                .get();
      } else {
        postsData = userId == null
            ? await _firebaseFirestore
                .collection(postsCollection)
                .orderBy('created_at', descending: true)
                .limit(pageSize)
                .get()
            : await _firebaseFirestore
                .collection(postsCollection)
                .where(
                  'user_model',
                  isEqualTo: _firebaseFirestore
                      .collection(usersCollection)
                      .doc(userId),
                )
                .orderBy('created_at', descending: true)
                .limit(pageSize)
                .get();
      }

      for (var post in postsData.docs) {
        final likes = await getPostLikes(post.id);
        DocumentReference userRef = post['user_model'];
        DocumentSnapshot userSnapshot = await userRef.get();
        final postMap = post.data();
        postMap.addAll({'id': post.id});
        postMap.update('user_model', (value) => userSnapshot.data());
        final postModel = PostModel.fromJson(postMap);
        postsList.add(postModel.copyWith(likes: likes));
      }

      if (postsData.size < pageSize) {
        if (userId != null) {
          lastDocs.remove(userId);
        } else {
          globalLastDoc = null;
        }
      } else {
        if (userId != null) {
          lastDocs[userId] = postsData.docs.last;
        } else {
          globalLastDoc = postsData.docs.last;
        }
      }
    } catch (e) {
      // log('error:$e');
    }
    return postsList;
  }

  Future<List<UserModel>> getPostLikes(String postId) async {
    final List<UserModel> likes = [];
    final likesData = await _firebaseFirestore
        .collection(postsCollection)
        .doc(postId)
        .collection(postLikesCollection)
        .get();

    for (var doc in likesData.docs) {
      likes.add(UserModel.fromDocument(doc));
    }

    return likes;
  }

  Future likePost(String postId, UserModel userModel) async {
    await _firebaseFirestore
        .collection(postsCollection)
        .doc(postId)
        .collection(postLikesCollection)
        .doc(postId + userModel.id)
        .set(userModel.toJson());
  }

  Future unlikePost(String postId, UserModel userModel) async {
    await _firebaseFirestore
        .collection(postsCollection)
        .doc(postId)
        .collection(postLikesCollection)
        .doc(postId + userModel.id)
        .delete();
  }
}

final postsRepoProvider = Provider<PostsRepo>((ref) {
  return PostsRepo(ref);
});
