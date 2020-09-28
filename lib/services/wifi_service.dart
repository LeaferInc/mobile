import 'package:wifi/wifi.dart';

class WifiService{

  static Future<String> connectLeaferSensor() async {
    WifiState w = await Wifi.connection('leaferSensor', '123456789');
    if(Wifi.ssid.toString() == 'leaferSensor'){
      return "connexion au capteur reussie";
    }
    else {
      return "connexion au capteur échouée";
    }
  }

  static Future<String> connectBackToWifi(ssid, password) async {
    WifiState w = await Wifi.connection(ssid, password);
    if(Wifi.ssid.toString() == ssid){
      return "connexion au point d'accès reussie";
    }
    else {
      return "connexion au point d'accès échouée";
    }
  }

}