import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leafer/screens/chat/conversations.dart';

class ChatHome extends StatelessWidget {
  static const String TITLE = 'Conversations';

  const ChatHome({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Conversations'),
        ),
        body: Conversations(),
      ),
    );
  }
}