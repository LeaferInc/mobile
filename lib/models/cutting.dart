import 'dart:convert';

import 'package:leafer/models/user.dart';

class Cutting {
  DateTime createdAt;
  String name;
  String description;
  int ownerId;
  int viewCount;
  String tradeWith;
  User owner;

  Cutting({
    this.createdAt,
    this.name,
    this.description,
    this.viewCount,
    this.tradeWith,
    this.owner,
  });

  Cutting copyWith({
    DateTime createdAt,
    String name,
    String description,
    int ownerId,
    int viewCount,
    String tradeWith,
    User owner,
  }) {
    return Cutting(
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      description: description ?? this.description,
      viewCount: viewCount ?? this.viewCount,
      tradeWith: tradeWith ?? this.tradeWith,
      owner: owner ?? this.owner,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'name': name,
      'description': description,
      'ownerId': ownerId,
      'viewCount': viewCount,
      'tradeWith': tradeWith,
      'owner': owner?.toMap(),
    };
  }

  static Cutting fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Cutting(
      createdAt: new DateTime(map['createdAt']),
      name: map['name'],
      description: map['description'],
      viewCount: map['viewCount'],
      tradeWith: map['tradeWith'],
      owner: User.fromMap(map['owner']),
    );
  }

  // String toJson() => json.encode(toMap());

  static Cutting fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Cutting(createdAt: $createdAt, name: $name, description: $description, ownerId: $ownerId, viewCount: $viewCount, tradeWith: $tradeWith, owner: $owner)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Cutting &&
        o.createdAt == createdAt &&
        o.name == name &&
        o.description == description &&
        o.ownerId == ownerId &&
        o.viewCount == viewCount &&
        o.tradeWith == tradeWith &&
        o.owner == owner;
  }

  @override
  int get hashCode {
    return createdAt.hashCode ^
        name.hashCode ^
        description.hashCode ^
        ownerId.hashCode ^
        viewCount.hashCode ^
        tradeWith.hashCode ^
        owner.hashCode;
  }
}
