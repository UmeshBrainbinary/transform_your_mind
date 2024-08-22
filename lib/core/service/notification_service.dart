import 'dart:async';
import 'dart:convert';
import 'package:googleapis_auth/auth_io.dart' as auth;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
class NotificationService {
  static Map<String, dynamic> noti = {};

  static Future<void> init() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      playSound: true,
      showBadge: true,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      RemoteNotification? notification = message?.notification;
      AndroidNotification? android = message?.notification?.android;

      if (notification != null && android != null) {
        Map<String, dynamic> payload = message!.data;
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: android.smallIcon,
              playSound: true,
            ),
          ),
          payload: jsonEncode(payload),
        );
        noti = {
          "title": notification.title,
          "body": notification.body,
        };
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      // Handle notification tap when the app is in the background
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {

      // Handle notification tap when the app is terminated
        });


    await FirebaseMessaging.instance.setAutoInitEnabled(true);

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
      defaultPresentBanner: true,
      requestAlertPermission: true,
      requestProvisionalPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification response
      },
    );
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    // Handle background message
  }

  static Future<String?> getToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<String?> apnsToken() async {
    try {
      return await FirebaseMessaging.instance.getAPNSToken();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static FirebaseMessaging message = FirebaseMessaging.instance;

  static Future<String?> getFcmToken() async {
    return await message.getToken();
  }



  static Future<String> generateFCMAccessToken() async {
    try {
      /* get these details from the file you downloaded(generated)
          from firebase console
      */



    String type = "service_account";
      String project_id = "transform-your-mind-afbb7";
      String private_key_id = "87887bbb4cfbb15d9a45bdc337a49a67ef12c5e6";
      String private_key = "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCtPsTLIVl/lpL2\n6ANk6JmUcz9pg5aStFM7WINLQIOmJjTTAoL86Rx8ncOjTdm8PUZFPnlDdsiBv+vJ\nvWOk2LvkANE5Ehfw6wG3xBVKLMtsgc9wcjJ6llZu870jBWPemCOFBkyTm2T+qBo9\noGVQDTP8Z5sXBqAXgSSlj4gFPJ5S701bVEzvCkQbrA+aAYLQoz0y9cmRprBRl7V5\nndGsWFZ6bfzHwB/o54VQ20vOQkSX9r3rgS+l6FFnuZ4023HVbSIKm1yMzpYhKQ+V\nPRMc+ssd9C8uRZoIS1zgPhr36VEGVV2ZNNJKPw8BB9w67aCLfYPZ7HBWBV3q7QK6\n4H3TJOxrAgMBAAECggEACCcIA7cSCxr+13ebkUgQ0heKSGDU2Rp7QDOuGgBzMYJi\nwftARr6BhKu35Rtov57yi5ehBTe1v8VURy4OXleEn/oZ3mGnlsK4Vfl4NwFcoUKK\njHQTRAmHD7mQkPFT/cmTAlOFjvylCAbJFVVS7y1v4NTPS4oYRoLhQpk6gWSU3roo\nOQ96L18jOp/ItCAEkN47hNYNTGDj+xnEzkHOof9bepC1uGJwv+XiNX6ncTctdfLs\nkya8fCiGF3XNDxWFrSYYr/S1O0u+kjlHoljwGUaO0uBp9JldOhKdKg5sapfpVlbw\n+W6XxARR9E1g1dRSpAbIYe0PN+jNOFEl1SwB4h/XoQKBgQDlb6nq+ptxz4fqNvJr\n9jDkPLihwzKEyMegsVKypzpenN+Gk6DPjJ4ptxybt6UTkaTccw3OFmhJXb3VZtio\n4Bh1E9SrQaREYVliV67V9JAS5WruO4xiqlv+7nQq39olcmG0QH3PFiD8KNVZUJ2T\nkDLYs4kMQ6XBYZe0TxzZeuMczwKBgQDBTaQi9qW5P5sSIuqCBwoOVL0k8svMPaCb\nlkVnFoy+7XqEDuvBDwkZk7JTIQWPj8A9RbTSi26UKN8vqZrLZJTwMm1Gtar+k6mr\nnHh0F5gzSYiFQ3b9Tqyw5d6moSm9J69RqHCFeiuGAmvb939+LU+dekYTo3jAorQX\nHEE66Yu1pQKBgB67CB1LF8r0qxW56lp/jSjk4S35gSi749EoLxVyxKSrilzyJRXn\nlb+soQ5SWK/4UAae+nhiE/HPtn+A2QA1k9EKqO+PSTtHdrtvVyGdMjb1t47VNwZ4\nHv5UXgboGMXvPhrwkGlOY3ii14CxBYogRE82LOMRpH/0XGdwOUL/7K+NAoGBALvi\nj2s8eZA5dqyGK5H+7ZNIYiALrnLyY61WvlaY4GyjvrWlGxknWBz4JhgOvKzxeFUV\n78/FntF7eJOHMuIG/Y0KNpTH91BCjmQzThDo7hLLolqFXJ6RXeEDTQqBE2S7sfiY\n0+Wo/azfpZ7ETbOCryPNuVdVSQVUH99mozBz2EvRAoGBALtcHc7Dq7mr6oej1nC3\nH+J0aZ1G38yQK/3SBbitalJBsKsgqvhshuM/biP2bdjDXWamO5X4HkCLJIIkWF8f\nJ7fsHgJ4EHVTQixXBFExW9MLbhFYHMHCWHrfLvHno0kdniySmzrIwcJkqzCh2lT7\n/MyJIyk0n1TBvKSkyeaBwzUI\n-----END PRIVATE KEY-----\n";
      String client_email = "transform-your-mind@transform-your-mind-afbb7.iam.gserviceaccount.com";
      String client_id = "103164384294368438059";
      String auth_uri = "https://accounts.google.com/o/oauth2/auth";
      String token_uri = "https://oauth2.googleapis.com/token";
      String auth_provider_x509_cert_url = "https://www.googleapis.com/oauth2/v1/certs";
      String client_x509_cert_url = "https://www.googleapis.com/robot/v1/metadata/x509/transform-your-mind%40transform-your-mind-afbb7.iam.gserviceaccount.com";
      String universe_domain = "googleapis.com";

      final credentials = auth.ServiceAccountCredentials.fromJson({
        "type": type,
        "project_id": project_id,
        "private_key_id": private_key_id,
        "client_email": client_email,
        "private_key": private_key,
        "client_id": client_id,
        "auth_uri": auth_uri,
        "token_uri": token_uri,
        "auth_provider_x509_cert_url": auth_provider_x509_cert_url,
        "client_x509_cert_url": client_x509_cert_url,
        "universe_domain": universe_domain
      });

      List<String> scopes = [
        "https://www.googleapis.com/auth/firebase.messaging"
      ];

      final client = await auth.obtainAccessCredentialsViaServiceAccount(
          credentials, scopes, http.Client());
      final accessToken = client;
      Timer.periodic(const Duration(minutes: 59), (timer) {
        accessToken.refreshToken;
      });
      return accessToken.accessToken.data;
    } catch (e) {
      print("THis is the error: $e");
    }
    return "";
  }

}
