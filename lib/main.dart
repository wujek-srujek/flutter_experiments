import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
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
    _showSnackbarForNotification('Foreground', message);
  });
  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

  runApp(const MyApp());
}

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  log('>>> Background message received');
  // No UI but can execute API calls etc.
}

// Used to handle the message when the UI is available. It is used either when
// the app is in the foreground or when the app is launched by clicking on the
// notification and using FirebaseMesseging handling.
void _showSnackbarForNotification(String appState, RemoteMessage message) {
  log('>>> App state: $appState');
  log('>>> Message map: ${message.toMap()}');

  final messageData = message.data['message'] as String?;
  if (messageData != null) {
    _scaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        content: Text('($appState) $messageData'),
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

class MyApp extends StatefulWidget {
  const MyApp();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    _setupBackgroundMessageHandling();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Experiments',
      scaffoldMessengerKey: _scaffoldMessengerKey,
      home: MyPage(),
    );
  }

  Future<void> _setupBackgroundMessageHandling() async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _showSnackbarForNotification('Terminated', initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      _showSnackbarForNotification('Background', remoteMessage);
    });
  }
}

class MyPage extends StatefulWidget {
  const MyPage();

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String? _data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () async {
                final callable =
                    FirebaseFunctions.instanceFor(region: 'europe-west3')
                        .httpsCallable('hello');
                final futureResult = callable<String>();
                final result = await futureResult;
                setState(() {
                  _data = result.data;
                });
              },
              child: const Text('Call function'),
            ),
            Text(_data ?? '<No data>'),
          ],
        ),
      ),
    );
  }
}

const _scaffoldMessengerKey = GlobalObjectKey<ScaffoldMessengerState>(true);
