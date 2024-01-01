import 'package:clinigram_app/core/core.dart';
import 'package:clinigram_app/features/profile/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'consultation_model.freezed.dart';
part 'consultation_model.g.dart';

@freezed
class ConsultationModel with _$ConsultationModel {
  const ConsultationModel._();
  factory ConsultationModel({
    @Default('') String id,
    required String description,
    @Default('') String fileUrl,
    required UserModel patient,
    UserModel? doctor,
    @Default(AttatchmentType.none) AttatchmentType attatchmentType,
    required DateTime createdAt,
  }) = _ConsultationModel;
  factory ConsultationModel.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ConsultationModel.fromJson(data).copyWith(
        id: doc.id,
        attatchmentType: stringToAttatchmentType(doc['attatchment_type']));
  }

  factory ConsultationModel.fromJson(Map<String, dynamic> json) =>
      _$ConsultationModelFromJson(json);

  Map<String, dynamic> toDocument() => toJson()
    ..remove('id')
    ..update('patient', (value) => patient.toDocument(excludeLists: true));
}
