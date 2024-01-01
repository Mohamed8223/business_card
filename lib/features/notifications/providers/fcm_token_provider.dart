import 'package:firebase_messaging/firebase_messaging.dart'
    show FirebaseMessaging;
import 'package:hooks_riverpod/hooks_riverpod.dart' show FutureProvider;

final fcmTokenProvider = FutureProvider<String>((ref) async {
  final fcmToken = await FirebaseMessaging.instance.getToken();
  return fcmToken ?? '';
});
