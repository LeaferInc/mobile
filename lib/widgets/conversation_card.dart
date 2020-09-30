import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leafer/models/message.dart';
import 'package:leafer/models/user.dart';
import 'package:leafer/services/message_service.dart';

class ConversationCard extends StatefulWidget {
  final User user;
  final VoidCallback onTap;

  ConversationCard({Key key, @required this.user, @required this.onTap}) : super(key: key);

  @override
  _ConversationCardState createState() => _ConversationCardState(user, onTap);
}

class _ConversationCardState extends State<ConversationCard> {
  final User _user;
  final VoidCallback _onTap;

  _ConversationCardState(this._user, this._onTap);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: 
          Row(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: _user.getPicture(),
              ),
              Text(
                  _user.username,
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.black, fontSize: 22)
              )
            ],
          )
          
       ),
    );
  }
}