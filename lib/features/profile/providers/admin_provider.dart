import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/core.dart';
import '../data/models/models.dart';

final adminProvider = FutureProvider<UserModel?>((ref) async {
  final firebaseFirestore = FirebaseFirestore.instance;
  final userSnapshot = await firebaseFirestore
      .collection(usersCollection)
      .where('accont_type', isEqualTo: 'admin')
      .get();
  if (userSnapshot.docs.isNotEmpty) {
    return UserModel.fromDocument(userSnapshot.docs.first);
  }
  return null;
});
