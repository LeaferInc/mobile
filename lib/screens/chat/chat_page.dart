import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leafer/models/message.dart';
import 'package:leafer/models/user.dart';
import 'package:leafer/services/message_service.dart';
import 'package:leafer/services/socketio_service.dart';
import 'package:leafer/services/user_service.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatPage extends StatefulWidget {
  final User interlocutor;

  ChatPage({Key key, @required this.interlocutor}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState(interlocutor);
}

class _ChatPageState extends State<ChatPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Message> messages;
  final User _interlocutor;
  double height, width;
  TextEditingController textController;
  ScrollController scrollController;

  User _currentUser;
  Socket _socketIO;

  _ChatPageState(this._interlocutor);

  @override
  void initState() { 
    this.setState(() {
      messages = List<Message>();
      textController = TextEditingController();
      scrollController = ScrollController();
    });
    initSocketIO();
    getMessages();
    super.initState();
  }

  void initSocketIO() async {
    User cUser = await UserService.getCurrentUser();
    Socket socket = await SocketioService.initSocket();
    this.setState(() {
      _currentUser = cUser;
      _currentUser.roomId = _interlocutor.roomId;
      _socketIO = socket;
      _socketIO.emit('joinRoom', _interlocutor.roomId);
      _socketIO.on('messageServerToClient', (data) {
        Message newMessage = Message.fromMap(data);
        messages.add(newMessage);
        scrollController.animateTo(scrollController.position.maxScrollExtent + height * 0.1, duration: Duration(milliseconds: 600), curve: Curves.ease);
      });
    });
  }

  void getMessages() async {
    List<Message> m = await MessageService.getConversationById(this._interlocutor.roomId);
    this.setState(() {
      messages = m;
    });
  }

  void scrollToEnd() async {
    scrollController.animateTo(scrollController.position.maxScrollExtent + height * 0.1, duration: Duration(milliseconds: 600), curve: Curves.ease);
  }

  Widget buildMessageList() {
    return Container(
      height: height * 0.8,
      width: width,
      child: ListView.builder(
        controller: scrollController,
        shrinkWrap: true,
        itemCount: messages.length,
        itemBuilder: (BuildContext context, int index) {
            return buildSingleMessage(index);
        },
      ),
    );
  }

  Widget buildSingleMessage(int index) {

    if(messages[index].user.id == _currentUser.id){
      return Container(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          margin: const EdgeInsets.only(bottom: 20.0, right: 20.0),
          
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            messages[index].messageContent,
            style: TextStyle(color: Colors.white, fontSize: 15.0),
          ),
        ),
      );
    }
    else{
      return Container(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          margin: const EdgeInsets.only(bottom: 20.0, left: 20.0),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            messages[index].messageContent,
            style: TextStyle(color: Colors.white, fontSize: 15.0),
          ),
        ),
      );
    }

    
  }

  Widget buildChatInput() {
    return Container(
      width: width * 0.7,
      padding: const EdgeInsets.all(2.0),
      margin: const EdgeInsets.only(left: 40.0),
      child: TextField(
        decoration: InputDecoration.collapsed(
          hintText: 'Send a message...',
        ),
        controller: textController,
      ),
    );
  }

  void sendMessage(Message message) async {
    await MessageService.saveMessage(message);
  }

  Widget buildSendButton() {
    return FloatingActionButton(
      backgroundColor: Colors.deepPurple,
      onPressed: () {
        if (textController.text.isNotEmpty) {
          Message newMessage = Message(DateTime.now(), textController.text, _currentUser, _currentUser.room, _currentUser.roomId);
          sendMessage(newMessage);
          _socketIO.emit(
              'send_message', jsonEncode({'message': textController.text}));
          textController.text = '';
          scrollToEnd();
        }
      },
      child: Icon(
        Icons.send,
        size: 30,
      ),
    );
  }

  Widget buildInputArea() {
    return Container(
      height: height * 0.1,
      width: width,
      child: Row(
        children: <Widget>[
          buildChatInput(),
          buildSendButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_interlocutor.username),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            buildMessageList(),
            buildInputArea(),
          ],
        ),
      ),
    );
  }

  void onBackPress(){
    Navigator.pop(context);
  }

}