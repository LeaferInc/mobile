import 'package:leafer/models/message.dart';
import 'package:leafer/models/user.dart';
import 'package:leafer/services/socketio_service.dart';
import 'package:leafer/services/user_service.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatModel{
  User currentUser;
  List<User> conversations = List<User>();
  List<Message> messages = List<Message>();
  Socket socketIO;

  void init() async{
    currentUser = await UserService.getCurrentUser();
    socketIO = await SocketioService.initSocket();
    socketIO.on('init', (data) => print("[init]" + data.toString()));
    socketIO.on('error', (data) => print("[error] " + data.toString()));
    socketIO.on('disconnect', (data) => print("[disconnect] " + data.toString()));
    socketIO.on('connecting', (data) => print("[connecting] " + data.toString()));
    socketIO.on('connect', (data) => print("[connect] " + data.toString()));
    socketIO.on('connect_error', (data) => print("[connect_error] " + data.toString()));
    socketIO.on('connect_timeout', (data) => print("[connect_timeout] " + data.toString()));
  }
}