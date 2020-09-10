import 'package:leafer/data/rest_ds.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketioService {
  // static const _BASE_URL_SOCKET = RestDatasource.HOST + "/chat";

  static Future<Socket> initSocket() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('jwt');
    Socket socketIO = io("http://10.0.2.2:3000/chat", <String, dynamic>
      {
        'transports': ['websocket'],
        'extraHeaders': {
          'Authorization': 'Bearer ' + token
        }
      }
    );
    return socketIO;
  }
}