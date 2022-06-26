import 'dart:developer';

import 'package:flutter/material.dart';

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

class _ConversationWidget extends StatelessWidget {
  const _ConversationWidget();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 0,
      itemBuilder: (context, index) {
        return _MessageWidget(
          name: 'name',
          message: 'message ${index + 1}',
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

            log('Message: $message');
          },
          icon: const Icon(Icons.send_rounded),
        ),
      ],
    );
  }
}
