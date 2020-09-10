import 'package:flutter/cupertino.dart';
import 'package:leafer/models/chat_model.dart';

class Conversations extends StatefulWidget {
  Conversations({Key key}) : super(key: key);

  @override
  _ConversationsState createState() => _ConversationsState();
}

class _ConversationsState extends State<Conversations> {

  @override
  void initState() {
    // TODO: implement initState
    ChatModel chatModel = ChatModel();
    chatModel.init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
    );
  }
}