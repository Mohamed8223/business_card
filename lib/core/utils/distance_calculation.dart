import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

// For web
import 'package:clinigram_app/core/utils/location_web.dart'
    if (dart.library.io) 'package:clinigram_app/core/utils/location_mobile.dart';

int? calculateDistance(GeoPoint point1) {
  GeoPoint? point2;
  int result = 0;
  getCurrentPositionImpl(
    (lat, lng) {
      var earthRadiusKm = 6371;

      point2 = GeoPoint(lat, lng);

      var dLat = degreesToRadians(point1.latitude - point2!.latitude);
      var dLon = degreesToRadians(point1.longitude - point2!.longitude);

      var lat1 = degreesToRadians(point1.latitude);
      var lat2 = degreesToRadians(point2!.latitude);

      var a = sin(dLat / 2) * sin(dLat / 2) +
          sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
      var c = 2 * atan2(sqrt(a), sqrt(1 - a));
      result = (earthRadiusKm * c).toInt();
    },
    (errorMessage) {},
  );

  return result;
}

degreesToRadians(degrees) {
  return degrees * pi / 180;
}

calculateLimitDistances(double distance, GeoPoint center) {
  double lat = 0.0144927536231884;
  double lon = 0.0181818181818182;
  distance = distance * 0.621371;
  double lowerLat = center.latitude - (lat * distance);
  double lowerLon = center.longitude - (lon * distance);
  double greaterLat = center.latitude + (lat * distance);
  double greaterLon = center.longitude + (lon * distance);
  GeoPoint lesserGeopoint = GeoPoint(lowerLat, lowerLon);
  GeoPoint greaterGeopoint = GeoPoint(greaterLat, greaterLon);
  return (lesserGeopoint, greaterGeopoint);
}
