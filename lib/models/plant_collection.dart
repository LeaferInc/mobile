import 'dart:convert';

import 'package:leafer/models/plant.dart';
import 'package:leafer/models/user.dart';

class PlantCollection {
  int id;
  int userId;
  int plantId;
  PlantCollection({
    this.id,
    this.userId,
    this.plantId,
  });

  PlantCollection copyWith({
    int id,
    DateTime creationDate,
    User user,
    int plantId,
  }) {
    return PlantCollection(
      id: id ?? this.id,
      userId: user ?? this.userId,
      plantId: plantId ?? this.plantId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': userId,
      'plantId': plantId,
    };
  }

  static PlantCollection fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return PlantCollection(
      id: map['id'],
      userId: map['userId'],
      plantId: map['plantId'],
    );
  }

  // String toJson() => json.encode(toMap());

  static PlantCollection fromJson(String source) =>
      fromMap(json.decode(source));

  @override
  String toString() {
    return 'PlantCollection(id: $id, userId: $userId, plant: $plantId)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PlantCollection &&
        o.id == id &&
        o.userId == userId &&
        o.plantId == plantId;
  }

  @override
  int get hashCode {
    return id.hashCode ^ userId.hashCode ^ plantId.hashCode;
  }
}
