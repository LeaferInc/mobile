import 'dart:convert';

class Sensor {
  int id;
  Sensor({
    this.id,
  });

  Sensor copyWith({
    int id,
  }) {
    return Sensor(
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }

  factory Sensor.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Sensor(
      id: map['id'],
    );
  }

  // String toJson() => json.encode(toMap());

  factory Sensor.fromJson(String source) => Sensor.fromMap(json.decode(source));

  @override
  String toString() => 'Sensor(id: $id)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Sensor &&
      o.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
