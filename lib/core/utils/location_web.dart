// location_web.dart


import 'package:js/js.dart';

@JS('getCurrentPosition')
external void getCurrentPosition(
    void Function(double lat, double lng) successCallback,
    void Function(String errorMessage) errorCallback);

void getCurrentPositionImpl(
    void Function(double lat, double lng) successCallback,
    void Function(String errorMessage) errorCallback) async {
  getCurrentPosition(
    allowInterop((lat, lng) {
      successCallback(lat, lng);
    }),
    allowInterop((errorMessage) {
      errorCallback(errorMessage);
    }),
  );
}
