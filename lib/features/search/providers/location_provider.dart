


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// For web
import 'package:clinigram_app/core/utils/location_web.dart'
if (dart.library.io) 'package:clinigram_app/core/utils/location_mobile.dart';

class LocationNotifier extends StateNotifier<GeoPoint?>{
  LocationNotifier():super(null){
    // getLocation();
  }
  GeoPoint? location;
  getLocation(){
    if (location==null){
      getCurrentPositionImpl(
            (lat, lng) {
          state=GeoPoint(lat, lng);
          location=GeoPoint(lat, lng);
        },
            (errorMessage) {},
      );
    }

  }

}

final locationProvider=StateNotifierProvider<LocationNotifier,GeoPoint?>((ref) => LocationNotifier());