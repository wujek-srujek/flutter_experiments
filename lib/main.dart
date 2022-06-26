import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate();

  await FirebaseAuth.instance.signInAnonymously();

  final messaging = FirebaseMessaging.instance;
  messaging.onTokenRefresh.listen((fcmToken) {
    log('>>> Token refreshed');
    _saveFcmToken(fcmToken);
  });
  final fcmToken = (await messaging.getToken())!;
  _saveFcmToken(fcmToken);

  FirebaseMessaging.onMessage.listen((message) {
    log('>>> Foreground message received');
    _messageHandler(message);
  });
  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

  runApp(const MyApp());
}

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  log('>>> Background message received');
  _messageHandler(message);
}

void _messageHandler(RemoteMessage message) {
  log('>>> Message map: ${message.toMap()}');

  final messageData = message.data['message'] as String?;
  if (messageData != null) {
    // If there is no context yet (the message arrived before the UI was built)
    // we don't show anything, which is OK for this experiment.
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(messageData),
      ),
    );
  }
}

void _saveFcmToken(String fcmToken) {
  log('>>> Saving FCM token: $fcmToken');
  final user = FirebaseAuth.instance.currentUser!;
  final db = FirebaseFirestore.instance;
  // Create or update the user and their FCM token.
  db
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

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Experiments',
      scaffoldMessengerKey: _scaffoldMessengerKey,
      home: MyPage(),
    );
  }
}

class MyPage extends StatelessWidget {
  const MyPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Firebase'),
      ),
    );
  }
}

const _scaffoldMessengerKey = GlobalObjectKey<ScaffoldMessengerState>(true);
