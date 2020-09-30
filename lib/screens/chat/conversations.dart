import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leafer/models/user.dart';
import 'package:leafer/screens/chat/chat_page.dart';
import 'package:leafer/services/user_service.dart';
import 'package:leafer/widgets/conversation_card.dart';
import 'package:random_string/random_string.dart';

class Conversations extends StatefulWidget {

  Conversations({Key key}) : super(key: key);

  @override
  _ConversationsState createState() => _ConversationsState();
}

class _ConversationsState extends State<Conversations> {
  List<User> _myConversations = new List<User>();

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  void _getUsers() async {
    List<User> data = await UserService.getTalkTo();
    setState(() {
      _myConversations = data;
    });
  }

  Widget _buildList(BuildContext context, List<User> users){
    return ListView.builder(
        key: Key(randomString(20)),
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, item) {
          final index = item;
          return _buildRow(users.elementAt(index));
        },
        itemCount: users.length);
  }

  Widget _buildRow(User user) {
    return Card(
      child: Stack(children: <Widget>[
        Row(children: <Widget>[
          ConversationCard(
            user: user,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(interlocutor: user)
                )
              );
            },
          )
        ],)
      ],)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: _buildList(context, _myConversations),
    );
  }
}