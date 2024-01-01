import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class GeoPointConverter
    implements JsonConverter<GeoPoint?, Map<String, dynamic>?> {
  const GeoPointConverter();

  @override
  GeoPoint? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final latitude = json['latitude'] as double;
    final longitude = json['longitude'] as double;
    return GeoPoint(latitude, longitude);
  }

  @override
  Map<String, dynamic>? toJson(GeoPoint? value) {
    if (value == null) return null;
    return {
      'latitude': value.latitude,
      'longitude': value.longitude,
    };
  }
}
