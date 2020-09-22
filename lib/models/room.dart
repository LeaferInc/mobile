import 'dart:convert';

class Room {
  int id;
  String name;
  
  Room({
    this.id,
    this.name,
  });

  Room copyWith({
    int id,
    String name,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Room.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Room(
      id: map['id'],
      name: map['name'],
    );
  }

  // String toJson() => json.encode(toMap());

  factory Room.fromJson(String source) => Room.fromMap(json.decode(source));

  @override
  String toString() => 'Room(id: $id, name: $name)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Room &&
      o.id == id &&
      o.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
