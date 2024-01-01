import 'package:clinigram_app/features/profile/data/models/rating_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/core.dart';
import '../../../auth/auth.dart';
import '../../profile.dart';

class ProfileRepo {
  ProfileRepo(this._ref);
  final Ref _ref;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addRatingAndComment(RatingModel rating, String userID) async {
    await _firebaseFirestore
        .collection(usersCollection)
        .doc(userID)
        .collection('ratings')
        .doc() // Optionally, you can generate a unique rating ID
        .set(rating.toDocument());
  }

  Future<List<RatingModel>> getRatingsForProfile(String userID) async {
    final ratingsSnapshot = await _firebaseFirestore
        .collection(usersCollection)
        .doc(userID)
        .collection('ratings')
        .get();

    return ratingsSnapshot.docs.map((doc) {
      return RatingModel.fromDocument(doc.data());
    }).toList();
  }

  Future<int> getRatingsLengthForProfile(String userID) async {
    final ratingsSnapshot = await _firebaseFirestore
        .collection(usersCollection)
        .doc(userID)
        .collection('ratings')
        .get();

    return ratingsSnapshot.docs.length;
  }

  Future<bool> hasUserRated(String userID, String itemID) async {
    final querySnapshot = await _firebaseFirestore
        .collection(usersCollection)
        .doc(userID)
        .collection('ratings')
        .where('itemID', isEqualTo: itemID)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future createUser(UserModel userModel, UserCredential userCredential) async {
    final userId = userCredential.user!.uid;

    await _firebaseFirestore
        .collection(usersCollection)
        .doc(userId)
        .set(userModel.toDocument());
    await _firebaseFirestore
        .collection(usersCollection)
        .doc(userId)
        .update({'id': userId});
  }

  Future<UserModel?> getUserById(String userId) async {
    //TODO: find better way
    final userSnapshot = await _firebaseFirestore
        .collection(usersCollection)
        .where('id', isEqualTo: userId)
        .get();
    final followersSnapshot = await _firebaseFirestore
        .collection(usersCollection)
        .doc(userId)
        .collection(followersCollection)
        .get();
    final follwingsSnapshot = await _firebaseFirestore
        .collection(usersCollection)
        .doc(userId)
        .collection(followingsCollection)
        .get();
    if (userSnapshot.docs.isNotEmpty) {
      final userData = UserModel.fromDocument(userSnapshot.docs.first);
      final userFollowers = followersSnapshot.docs
          .map((follower) => UserModel.fromDocument(follower))
          .toList();
      final userFollowings = follwingsSnapshot.docs
          .map((following) => UserModel.fromDocument(following))
          .toList();
      final userModel = userData.copyWith(
          followers: userFollowers, followings: userFollowings);
      _ref.read(accountTypeProvider.notifier).state = userModel.accontType;

      return userModel;
    } else {
      return null;
    }
  }

  Future<void> updateProfile(UserModel userModel) async {
    await _firebaseFirestore
        .collection(usersCollection)
        .doc(userModel.id)
        .update(userModel.toDocument());
  }

  Future follow(UserModel toBeFollowedUser, UserModel followerUserModel) async {
    await _firebaseFirestore
        .collection(usersCollection)
        .doc(toBeFollowedUser.id)
        .collection(followersCollection)
        .doc(toBeFollowedUser.id + followerUserModel.id)
        .set(followerUserModel.toDocument(excludeLists: true));
    await _firebaseFirestore
        .collection(usersCollection)
        .doc(followerUserModel.id)
        .collection(followingsCollection)
        .doc(followerUserModel.id + toBeFollowedUser.id)
        .set(toBeFollowedUser.toDocument(excludeLists: true));
  }

  Future unFollow(
      UserModel toBeFollowedUser, UserModel followerUserModel) async {
    await _firebaseFirestore
        .collection(usersCollection)
        .doc(toBeFollowedUser.id)
        .collection(followersCollection)
        .doc(toBeFollowedUser.id + followerUserModel.id)
        .delete();
    await _firebaseFirestore
        .collection(usersCollection)
        .doc(followerUserModel.id)
        .collection(followingsCollection)
        .doc(followerUserModel.id + toBeFollowedUser.id)
        .delete();
  }

  Future<UserModel?> getUserPhoneOrEmail(String? phone, String? email) async {
    Query userQuery =
        _firebaseFirestore.collection(preRegisterdDoctorsCollection);

    if (phone != null) {
      userQuery = userQuery.where('phone', isEqualTo: phone);
    } else if (email != null) {
      userQuery = userQuery.where('email', isEqualTo: email);
    } else {
      return null;
    }

    final userSnapshots = await userQuery.get();
    if (userSnapshots.docs.isNotEmpty) {
      final userData = UserModel.fromJson(
          userSnapshots.docs.first.data() as Map<String, dynamic>);

      final userModel = userData;

      _ref.read(accountTypeProvider.notifier).state = userModel.accontType;

      return userModel;
    } else {
      return null;
    }
  }
}

final profileRepoProvider = Provider<ProfileRepo>((ref) {
  return ProfileRepo(ref);
});
