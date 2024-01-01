import 'package:clinigram_app/features/consultations/consultations.dart';
import 'package:clinigram_app/features/profile/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/core.dart';

class ConsultationRepo {
  final _firebaseFirestore = FirebaseFirestore.instance;
  Future newConsultation(ConsultationModel consultationModel) async {
    await _firebaseFirestore
        .collection(consultationCollection)
        .add(consultationModel.toDocument());
  }

  Future<List<ConsultationModel>> getAllConsultation(
      UserModel userModel) async {
    final List<ConsultationModel> consultationList = [];

    late QuerySnapshot<Map<String, dynamic>> consulationSnapshots;
    switch (userModel.accontType) {
      case AccontType.admin:
        consulationSnapshots = await _firebaseFirestore
            .collection(consultationCollection)
            .orderBy('created_at', descending: true)
            .get();
        break;
      case AccontType.doctor:
        consulationSnapshots = await _firebaseFirestore
            .collection(consultationCollection)
            .where('doctor.id', isEqualTo: userModel.id)
            .orderBy('created_at', descending: true)
            .get();
        break;
      case AccontType.user:
        consulationSnapshots = await _firebaseFirestore
            .collection(consultationCollection)
            .where('patient.id', isEqualTo: userModel.id)
            .orderBy('created_at', descending: true)
            .get();
        break;
      default:
    }
    for (var consultationMap in consulationSnapshots.docs) {
      final consultationModel = ConsultationModel.fromDocument(consultationMap);
      consultationList.add(consultationModel);
    }
    return consultationList;
  }

  Future assignDoctorToConsultation(
      String consultationId, UserModel doctor) async {
    await _firebaseFirestore
        .collection(consultationCollection)
        .doc(consultationId)
        .update({'doctor': doctor.toDocument(excludeLists: true)});
  }
}

final consultationRepoProvider = Provider<ConsultationRepo>((ref) {
  return ConsultationRepo();
});
