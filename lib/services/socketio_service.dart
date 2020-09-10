import 'package:leafer/data/rest_ds.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketioService {
  static const _BASE_URL_SOCKET = RestDatasource.HOST + "/chat";

  static Future<Socket> initSocket() async {
    Socket socketIO;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt');
    socketIO = io(_BASE_URL_SOCKET, <String, dynamic>
      {
        'transports': ['websocket'],
        'transportOptions': {
          'polling': {
            'extraHeaders': {
              'Authorization': 'Bearer ' + token
            }
          }
        },
        'path': '/chat',
        'autoConnect': false,
      }
    );
    socketIO.on('connect', (_) {
      print('connect');
    });
    socketIO.connect();
    return socketIO;
  }
}