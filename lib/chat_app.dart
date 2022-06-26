import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'chat_page.dart';

class ChatApp extends StatelessWidget {
  const ChatApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Experiments',
      home: Stack(
        children: const [
          ChatPage(),
          _PermissionChecker(),
        ],
      ),
    );
  }
}

class _PermissionChecker extends StatefulWidget {
  const _PermissionChecker();

  @override
  State<_PermissionChecker> createState() => _PermissionCheckerState();
}

class _PermissionCheckerState extends State<_PermissionChecker>
    with
        // ignore: prefer_mixin
        WidgetsBindingObserver {
  late Future<void> _canReceiveFuture;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    _canReceiveFuture = _checkReceivePermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _canReceiveFuture.ignore();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _canReceiveFuture.ignore();
    } else if (state == AppLifecycleState.resumed) {
      _canReceiveFuture = _checkReceivePermission();
      setState(() {});
    }
  }

  Future<void> _checkReceivePermission() async {
    final messaging = FirebaseMessaging.instance;

    final notificationSettings = await messaging.requestPermission();
    final canReceiveNotifications = notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized;

    if (!canReceiveNotifications) {
      _scheduleNotificationWarning();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _canReceiveFuture,
      builder: (context, snapshot) {
        return const SizedBox.shrink();
      },
    );
  }

  void _scheduleNotificationWarning() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text(
              '''
Missing push notification permission, you can send messages but you will NOT
receive them.

Enable notifications in system settings for this app.
''',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    });
  }
}
