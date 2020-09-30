import 'dart:convert';

class SensorData {
  int sensorId;
  int groundHumidity;
  int airHumidity;
  int temperature;
  SensorData({
    this.sensorId,
    this.groundHumidity,
    this.airHumidity,
    this.temperature,
  });

  SensorData copyWith({
    int sensorId,
    int groundHumidity,
    int airHumidity,
    int temperature,
  }) {
    return SensorData(
      sensorId: sensorId ?? this.sensorId,
      groundHumidity: groundHumidity ?? this.groundHumidity,
      airHumidity: airHumidity ?? this.airHumidity,
      temperature: temperature ?? this.temperature,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sensorId': sensorId,
      'groundHumidity': groundHumidity,
      'airHumidity': airHumidity,
      'temperature': temperature,
    };
  }

  factory SensorData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return SensorData(
      sensorId: map['sensorId'],
      groundHumidity: map['groundHumidity'],
      airHumidity: map['airHumidity'],
      temperature: map['temperature'],
    );
  }

  // String toJson() => json.encode(toMap());

  factory SensorData.fromJson(String source) => SensorData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SensorData(sensorId: $sensorId, groundHumidity: $groundHumidity, airHumidity: $airHumidity, temperature: $temperature)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is SensorData &&
      o.sensorId == sensorId &&
      o.groundHumidity == groundHumidity &&
      o.airHumidity == airHumidity &&
      o.temperature == temperature;
  }

  @override
  int get hashCode {
    return sensorId.hashCode ^
      groundHumidity.hashCode ^
      airHumidity.hashCode ^
      temperature.hashCode;
  }
}
