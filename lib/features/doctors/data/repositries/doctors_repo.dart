import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/core.dart';
import '../../../profile/profile.dart';

class DocotrsRepo {
  DocotrsRepo(this._ref);
  final Ref _ref;
  final _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<UserModel>> getActiveDoctors({bool activeOlny = true}) async {
    final List<UserModel> docotrsList = [];

    final doctorsSnapshots = await _firebaseFirestore
        .collection(usersCollection)
        .where('accont_type', isEqualTo: AccontType.doctor.name)
        .where('is_active', isEqualTo: activeOlny)
        .get();

    for (var doctorMap in doctorsSnapshots.docs) {
      final doctorModel = UserModel.fromDocument(doctorMap);
      docotrsList.add(doctorModel);
    }
    return docotrsList;
  }

  Future<List<UserModel>> getPreRegisterDoctors() async {
    final List<UserModel> docotrsList = [];

    var doctorsSnapshots =
        _firebaseFirestore.collection(preRegisterdDoctorsCollection);

    // filter by name equals test if we run in localhost
    var finalSnapshot;
    if (kDebugMode) {
      finalSnapshot =
          await doctorsSnapshots.where("fullname_en", isEqualTo: "test").get();
    } else {
      finalSnapshot = await doctorsSnapshots.get();
    }

    for (var doctorMap in finalSnapshot.docs) {
      final doctorModel = UserModel.fromDocument(doctorMap);
      docotrsList.add(doctorModel);
    }
    return docotrsList;
  }

  Future<List<UserModel>> getAllDoctors({bool activeOlny = true}) async {
    final List<UserModel> docotrsList = [];

    final doctorsSnapshots = await _firebaseFirestore
        .collection(usersCollection)
        .where('accont_type', isEqualTo: AccontType.doctor.name)
        .get();

    for (var doctorMap in doctorsSnapshots.docs) {
      final doctorModel = UserModel.fromDocument(doctorMap);
      docotrsList.add(doctorModel);
    }
    return docotrsList;
  }

  Future<UserModel> addPreRegisterDoctor(UserModel doctorData) async {
    // the one who create add this doctor (Admin or Marketer)
    final createdByUser = _ref.read(currentUserProfileProvider);

    final docRef = await _firebaseFirestore
        .collection(preRegisterdDoctorsCollection)
        .add(doctorData.copyWith(createdBy: createdByUser.id).toDocument());

    return doctorData.copyWith(id: docRef.id, createdBy: createdByUser.id);
  }

  Future<void> deletePreRegisterDoctor(String doctorId) async {
    await _firebaseFirestore
        .collection(preRegisterdDoctorsCollection)
        .doc(doctorId)
        .delete();
  }

  Future<UserModel> updatePreRegisterDoctor(UserModel doctorData) async {
    await _firebaseFirestore
        .collection(preRegisterdDoctorsCollection)
        .doc(doctorData.id)
        .update(doctorData.toDocument(excludeLists: true));
    return doctorData;
  }
}

final doctorsRepoProvider = Provider<DocotrsRepo>((ref) {
  return DocotrsRepo(ref);
});
