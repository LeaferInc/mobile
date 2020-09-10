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
  }
}