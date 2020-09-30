import 'package:leafer/data/rest_ds.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketioService {
  // static const _BASE_URL_SOCKET = RestDatasource.HOST + "/chat";

  static Future<Socket> initSocket() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = 'Bearer ' + prefs.getString('jwt');
    Socket socketIO = io(RestDatasource.HOST + "/chat", <String, dynamic>
      {
        'transports': ['websocket'],
        'extraHeaders': {
          'Authorization': token
        }
      }
    );

    socketIO.on('init', (data) => print("[init]" + data.toString()));
    socketIO.on('error', (data) => print("[error] " + data.toString()));
    socketIO.on('disconnect', (data) => print("[disconnect] " + data.toString()));
    socketIO.on('connecting', (data) => print("[connecting] " + data.toString()));
    socketIO.on('connect', (data) => print("[connect] " + data.toString()));
    socketIO.on('connect_error', (data) => print("[connect_error] " + data.toString()));
    socketIO.on('connect_timeout', (data) => print("[connect_timeout] " + data.toString()));

    return socketIO;
  }


}