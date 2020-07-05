import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:leafer/models/image_model.dart';

class Cutting implements IImageModel {
  String name;
  String description;
  int ownerId;
  int viewCount;
  String tradeWith;
  Uint8List picture;

  Cutting({
    this.name,
    this.description,
    this.viewCount,
    this.tradeWith,
    this.ownerId,
    this.picture,
  });

  Cutting copyWith({
    DateTime createdAt,
    String name,
    String description,
    int ownerId,
    int viewCount,
    String tradeWith,
    Uint8List picture,
  }) {
    return Cutting(
      name: name ?? this.name,
      description: description ?? this.description,
      viewCount: viewCount ?? this.viewCount,
      tradeWith: tradeWith ?? this.tradeWith,
      ownerId: ownerId ?? this.ownerId,
      picture: picture ?? this.picture,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'ownerId': ownerId,
        'viewsCount': viewCount,
        'tradeWith': tradeWith,
        'picture': this.picture == null ? base64Encode(this.picture) : null,
      };

  static Cutting fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Cutting(
      name: map['name'],
      description: map['description'],
      viewCount: map['viewsCount'],
      tradeWith: map['tradeWith'],
      ownerId: map['ownerId'],
      picture: map['picture'] != null ? base64Decode(map['picture']) : null,
    );
  }

  // String toJson() => json.encode(toMap());

  static Cutting fromJson(String source) => fromMap(json.decode(source));

  @override
  ImageProvider getPicture() {
    if (this.picture == null) {
      return AssetImage('assets/images/cutting.png');
    } else {
      return MemoryImage(this.picture);
    }
  }

  @override
  String toString() {
    return 'Cutting(name: $name, description: $description, ownerId: $ownerId, viewCount: $viewCount, tradeWith: $tradeWith)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Cutting &&
        o.name == name &&
        o.description == description &&
        o.ownerId == ownerId &&
        o.viewCount == viewCount &&
        o.tradeWith == tradeWith;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        description.hashCode ^
        ownerId.hashCode ^
        viewCount.hashCode ^
        tradeWith.hashCode;
  }
}
