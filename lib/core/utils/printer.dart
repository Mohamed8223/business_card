// method that prints a string if debug mode is on
import 'package:flutter/foundation.dart';

void printDebug(String message) {
  if (kDebugMode) {
    print(message);
  }
}
