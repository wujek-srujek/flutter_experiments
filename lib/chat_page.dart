import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ChatPage extends StatelessWidget {
  const ChatPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SafeArea(
          child: Column(
            children: const [
              Expanded(
                child: _ConversationWidget(),
              ),
              SizedBox(height: 8),
              _SendWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConversationWidget extends StatefulWidget {
  const _ConversationWidget();

  @override
  State<_ConversationWidget> createState() => _ConversationWidgetState();
}

class _ConversationWidgetState extends State<_ConversationWidget> {
  final _scrollController = ScrollController();
  late final StreamSubscription<Map<String, dynamic>> _subscription;
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();

    _messages = [];

    FirebaseFirestore.instance
        .collection(_messagesCollection)
        .orderBy(_sentAtProperty)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs)
        .map(
          (docSnapshots) => docSnapshots
              .map((docSnapshot) => docSnapshot.data())
              .toList(growable: false),
        )
        .listen((messages) {
      setState(() {
        _messages = messages;
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent,
      );
    });

    return ListView.builder(
      controller: _scrollController,
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];

        return _MessageWidget(
          name: message[_sentByProperty]! as String,
          message: message[_messageProperty]! as String,
        );
      },
    );
  }
}

class _MessageWidget extends StatelessWidget {
  final String name;
  final String message;

  const _MessageWidget({
    required this.name,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(name),
          Text(
            message,
            style: Theme.of(context).textTheme.headline5,
          ),
        ],
      ),
    );
  }
}

class _SendWidget extends StatefulWidget {
  const _SendWidget();

  @override
  State<_SendWidget> createState() => _SendWidgetState();
}

class _SendWidgetState extends State<_SendWidget> {
  final uuid = const Uuid();
  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();

    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            final message = _messageController.text.trim();
            _messageController.clear();
            if (message.isEmpty) {
              return;
            }

            FirebaseFirestore.instance
                .collection(_messagesCollection)
                .doc(uuid.v1())
                .set(
              {
                _sentAtProperty: DateTime.now().toUtc().toIso8601String(),
                _sentByProperty: FirebaseAuth.instance.currentUser!.uid,
                _messageProperty: message,
              },
              SetOptions(
                merge: true,
              ),
            );
          },
          icon: const Icon(Icons.send_rounded),
        ),
      ],
    );
  }
}

const _messagesCollection = '/messages';
const _sentAtProperty = 'sentAt';
const _sentByProperty = 'sentBy';
const _messageProperty = 'message';
