// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:googleapis_auth/auth_io.dart';

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    print(
      '''
Arguments: fcmToken [message]

You can get FCM token when starting the Flutter app in debug mode
or look it up in Cloud Firestore.''',
    );
    exitCode = 1;

    return;
  }

  final fcmToken = args[0];
  final message = args.length > 1 ? args[1] : 'Hello, world!';
  final timestampedMessage = '(${DateTime.now()}) $message';

  final key = _serviceAccountKey();
  final client = await _authenticatedClient(key);

  try {
    await client.post(
      Uri.parse(
        'https://fcm.googleapis.com/v1/projects/${key['project_id']}/messages:send',
      ),
      body: _notification(fcmToken, timestampedMessage),
    );
  } finally {
    client.close();
  }
}

String _notification(String fcmToken, String message) => '''
{
    "message": {
        "token": "$fcmToken",
        "notification" : {
            "title": "Flutter Experiments",
            "body" : "$message"
        },
        "data": {
            "message": "$message"
        }
    }
}
''';

Map<String, dynamic> _serviceAccountKey() {
  final jsonString = File('service-account-key.json').readAsStringSync();

  return jsonDecode(jsonString) as Map<String, dynamic>;
}

Future<AuthClient> _authenticatedClient(Map<String, dynamic> key) {
  return clientViaServiceAccount(
    ServiceAccountCredentials.fromJson(key),
    ['https://www.googleapis.com/auth/firebase.messaging'],
  );
}
