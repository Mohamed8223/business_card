import 'package:cloud_firestore/cloud_firestore.dart';

extension GeoExtensions on GeoPoint {
  double get latitude => this.latitude;
  double get longitude => this.longitude;
  String toFormattedString() {
    return '$latitude,$longitude';
  }
}
