import 'dart:convert';

class Cutting {
  DateTime createdAt;
  String name;
  String description;
  int ownerId;
  int viewCount;
  String tradeWith;

  Cutting(
      {this.createdAt,
      this.name,
      this.description,
      this.viewCount,
      this.tradeWith,
      this.ownerId});

  Cutting copyWith({
    DateTime createdAt,
    String name,
    String description,
    int ownerId,
    int viewCount,
    String tradeWith,
  }) {
    return Cutting(
        createdAt: createdAt ?? this.createdAt,
        name: name ?? this.name,
        description: description ?? this.description,
        viewCount: viewCount ?? this.viewCount,
        tradeWith: tradeWith ?? this.tradeWith,
        ownerId: ownerId ?? this.ownerId);
  }

  Map<String, dynamic> toJson() => {
        'createdAt': createdAt.toString(),
        'name': name,
        'description': description,
        'ownerId': ownerId,
        'viewsCount': viewCount,
        'tradeWith': tradeWith,
      };

  static Cutting fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Cutting(
        createdAt: DateTime.parse(map['createdAt'].toString()),
        name: map['name'],
        description: map['description'],
        viewCount: map['viewsCount'],
        tradeWith: map['tradeWith'],
        ownerId: map['ownerId']);
  }

  // String toJson() => json.encode(toMap());

  static Cutting fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Cutting(createdAt: $createdAt, name: $name, description: $description, ownerId: $ownerId, viewCount: $viewCount, tradeWith: $tradeWith)';
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
        o.tradeWith == tradeWith;
  }

  @override
  int get hashCode {
    return createdAt.hashCode ^
        name.hashCode ^
        description.hashCode ^
        ownerId.hashCode ^
        viewCount.hashCode ^
        tradeWith.hashCode;
  }
}
