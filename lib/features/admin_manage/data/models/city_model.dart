import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/models/geo_location_model.dart';

part 'city_model.freezed.dart';
part 'city_model.g.dart';

@freezed
class CityModel with _$CityModel {
  const CityModel._();

  factory CityModel({
    String? id,
    required String nameAr,
    required String nameEn,
    required String nameHe,
    @GeoPointConverter() GeoPoint? cityLocation,
    @Default(false) bool visible,
  }) = _CityModel;

  factory CityModel.fromJson(Map<String, dynamic> json) =>
      _$CityModelFromJson(json);
  factory CityModel.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return CityModel.fromJson(data).copyWith(id: doc.id);
  }
  Map<String, dynamic> toDocument() => toJson()..remove('id');
  @override
  bool operator ==(Object other) {
    return (other is CityModel) && other.id == id;
  }
}
