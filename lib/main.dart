import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'chat_app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate();

  await FirebaseAuth.instance.signInAnonymously();

  final messaging = FirebaseMessaging.instance;
  messaging.onTokenRefresh.listen(_saveFcmToken);
  final fcmToken = (await messaging.getToken())!;
  _saveFcmToken(fcmToken);

  runApp(const ChatApp());
}

void _saveFcmToken(String fcmToken) {
  log('>>> Saving FCM token: $fcmToken');
  final user = FirebaseAuth.instance.currentUser!;
  // Create or update the user and their FCM token.
  FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('fcmTokens')
      .doc(fcmToken)
      .set(
    {
      'lastSavedAt': DateTime.now().toUtc().toIso8601String(),
    },
    SetOptions(
      merge: true,
    ),
  );
}
