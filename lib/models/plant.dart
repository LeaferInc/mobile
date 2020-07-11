import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:leafer/models/image_model.dart';

class Plant implements IImageModel {
  String name;
  int height;
  String humidity;
  String watering;
  String difficulty;
  String exposure;
  bool toxicity;
  String potting;
  Uint8List picture;

  Plant({
    this.name,
    this.height,
    this.humidity,
    this.watering,
    this.difficulty,
    this.exposure,
    this.toxicity,
    this.potting,
    this.picture,
  });

  Plant copyWith({
    String name,
    int height,
    String humidity,
    String watering,
    String difficulty,
    String exposure,
    bool toxicity,
    String potting,
    Uint8List picture,
  }) {
    return Plant(
      name: name ?? this.name,
      height: height ?? this.height,
      humidity: humidity ?? this.humidity,
      watering: watering ?? this.watering,
      difficulty: difficulty ?? this.difficulty,
      exposure: exposure ?? this.exposure,
      toxicity: toxicity ?? this.toxicity,
      potting: potting ?? this.potting,
      picture: picture ?? this.picture,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'height': height,
      'humidity': humidity,
      'watering': watering,
      'difficulty': difficulty,
      'exposure': exposure,
      'toxicity': toxicity,
      'potting': potting,
      'picture': this.picture == null ? base64Encode(this.picture) : null,
    };
  }

  static Plant fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Plant(
      name: map['name'] as String,
      height: map['height'] as int,
      humidity: map['humidity'] as String,
      watering: map['watering'] as String,
      difficulty: map['difficulty'] as String,
      exposure: map['exposure'] as String,
      toxicity: map['toxicity'] as bool,
      potting: map['potting'] as String,
      picture: map['picture'] == null ? null : base64Decode(map['picture']),
    );
  }

  // String toJson() => json.encode(toMap());

  static Plant fromJson(String source) => fromMap(json.decode(source));

  @override
  ImageProvider getPicture() {
    if (this.picture == null) {
      return AssetImage('assets/images/plant.png');
    } else {
      return MemoryImage(this.picture);
    }
  }

  @override
  String toString() {
    return 'Plant(name: $name, humidity: $humidity, watering: $watering, height: $height, '
        'difficulty: $difficulty, exposure: $exposure, toxicity: $toxicity, potting: $potting, picture: $picture)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Plant &&
        o.name == name &&
        o.height == height &&
        o.humidity == humidity &&
        o.watering == watering &&
        o.difficulty == difficulty &&
        o.exposure == exposure &&
        o.toxicity == toxicity &&
        o.potting == potting &&
        o.picture == picture;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        height.hashCode ^
        humidity.hashCode ^
        watering.hashCode ^
        difficulty.hashCode ^
        exposure.hashCode ^
        toxicity.hashCode ^
        potting.hashCode ^
        picture.hashCode;
  }
}
