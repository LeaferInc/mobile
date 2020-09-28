import 'dart:convert';

class SensorSettings {
  String ssid;
  String password;
  int plantCollection;
  int sensorId;

  SensorSettings(
      {this.ssid, this.password, this.plantCollection, this.sensorId});

  SensorSettings copyWith(
      {String ssid, String password, int plantCollection, int sensorId}) {
    return SensorSettings(
        ssid: ssid ?? this.ssid,
        password: password ?? this.password,
        plantCollection: plantCollection ?? this.plantCollection,
        sensorId: sensorId ?? this.sensorId);
  }

  Map<String, dynamic> toJson() {
    return {
      'ssid': ssid,
      'password': password,
      'plantCollection': plantCollection,
      'sensorId': sensorId
    };
  }

  static SensorSettings fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return SensorSettings(
        ssid: map['ssid'],
        password: map['password'],
        plantCollection: map['plantCollection'],
        sensorId: map['sensorId']);
  }

  // String toJson() => json.encode(toMap());

  static SensorSettings fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() =>
      'SensorSettings(ssid: $ssid, password: $password, plantCollection: $plantCollection, sensorId: $sensorId)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SensorSettings &&
        o.ssid == ssid &&
        o.password == password &&
        o.plantCollection == plantCollection &&
        o.sensorId == sensorId;
  }

  @override
  int get hashCode =>
      ssid.hashCode ^
      password.hashCode ^
      plantCollection.hashCode ^
      sensorId.hashCode;
}
