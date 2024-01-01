
import 'package:clinigram_app/app.dart';
import 'package:clinigram_app/core/core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:g_recaptcha_v3/g_recaptcha_v3.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // use local firebase functions for local development
  // if (!kReleaseMode) {
  //  FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  // }

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  if (kIsWeb) {
    printDebug('Running on the web! Initializing reCAPTCHA v3...');
    await GRecaptchaV3.ready('6Ld-pG4oAAAAAF7iaEQfM1QHaO6v-VRmL8lACRnP');

    var reCaptchaV3Provider =
        ReCaptchaV3Provider('6Ld-pG4oAAAAAF7iaEQfM1QHaO6v-VRmL8lACRnP');

    await FirebaseAppCheck.instance.activate(
      webProvider: reCaptchaV3Provider,
      // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
      // your preferred provider. Choose from:
      // 1. Debug provider
      // 2. Safety Net provider
      // 3. Play Integrity provider
      androidProvider: AndroidProvider.debug,
      // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
      // your preferred provider. Choose from:
      // 1. Debug provider
      // 2. Device Check provider
      // 3. App Attest provider
      // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
      appleProvider: AppleProvider.appAttest,
    );

    printDebug('reCAPTCHA v3 initialized!');
  }

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  await initializeDateFormatting();
  runApp(const ProviderScope(child: App()));
}
