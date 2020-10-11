import 'dart:convert';

class Sensor {
  int id;
  bool enabled;
  Sensor({
    this.id,
    this.enabled
  });

  Sensor copyWith({
    int id,
    bool enabled
  }) {
    return Sensor(
      id: id ?? this.id,
      enabled: enabled ?? this.enabled
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'enabled': enabled
    };
  }

  factory Sensor.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Sensor(
      id: map['id'],
      enabled: map['enabled']
    );
  }

  // String toJson() => json.encode(toMap());

  factory Sensor.fromJson(String source) => Sensor.fromMap(json.decode(source));

  @override
  String toString() => 'Sensor(id: $id, enabled:$enabled)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Sensor &&
      o.id == id &&
      o.enabled == enabled;
  }

  @override
  int get hashCode => id.hashCode ^ enabled.hashCode;
}
