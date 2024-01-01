import 'dart:io' show Platform;
import 'package:clinigram_app/core/constants/server_key.dart';

import '../models/models.dart';
import 'dart:convert' show json;
import '../../../../core/core.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final notificationsRepoProvider = Provider<NotificationsRepo>((ref) {
  return NotificationsRepo();
});
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  debugPrint('Handling a background message: ${message.toMap()}');
}

class NotificationsRepo {
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  late AndroidNotificationChannel _androidNotificationChannel;
  NotificationsRepo() {
    _initFCM();
  }

  Future<void> _initFCM() async {
    //initialize local notifications package.
    await _initFlutterLocalNotifications();

    // permissions
    await _setPermissions();

    //Create the channel on the device (if a channel with an id already exists,
    // it will be updated):
    // Android Notification Channel
    _androidNotificationChannel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidNotificationChannel);
    // From terminated
    await FirebaseMessaging.instance.getInitialMessage();
    // Foreground messages
    FirebaseMessaging.onMessage.listen((message) {
      // Firebase shows notification for ios automatically
      // thus show for android only
      if (Platform.isAndroid) {
        _showMessage(message);
      }
    });

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
      //
    }).onError((err) {
      // Error getting token.
      debugPrint(err.toString());
    });
    //background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _showMessage(RemoteMessage message) async {
    final RemoteNotification? notification = message.notification;
    final AndroidNotification? android = message.notification?.android;
    final AppleNotification? apple = notification?.apple;
    if (notification != null && (android != null || apple != null)) {
      final androidNotificationDetails = AndroidNotificationDetails(
        _androidNotificationChannel.id,
        _androidNotificationChannel.name,
        channelDescription: _androidNotificationChannel.description,
        icon: android?.smallIcon,
      );
      const iOSPlatformChannelSpecifics = DarwinNotificationDetails();
      final platformChannelSpecifics = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iOSPlatformChannelSpecifics,
      );
      await _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        platformChannelSpecifics,
      );
    }
  }

  Future<void> _initFlutterLocalNotifications() async {
    //initialize local notifications package
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const initializationSettingsAndroid =
        AndroidInitializationSettings('mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _setPermissions() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    await FirebaseMessaging.instance.requestPermission();
  }

  /// Send push notification
  Future<void> sendNotification({
    required String sendToToken,
    required NotificationModel notification,
  }) async {
    const endpoint = 'https://fcm.googleapis.com/fcm/send';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': serverKey
    };
    final bodyData = {
      "registration_ids": [sendToToken],
      "collapse_key": notification.type,
      "data": {
        'type': notification.type,
      },
      "notification": {
        "title": notification.title,
        "body": notification.body,
      },
    };
    await http.post(
      Uri.parse(endpoint),
      body: json.encode(bodyData),
      headers: headers,
    );
  }

  /// Store notification on Firebase
  Future<void> storeNotification({
    required NotificationModel notification,
  }) async {
    await FirebaseFirestore.instance
        .collection(notificationsCollection)
        .doc()
        .set(notification.toDocument());
  }
}
