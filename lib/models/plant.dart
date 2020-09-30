import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class Plant {
  int id;
  String name;
  int height;
  int humidityMax;
  int humidityMin;
  String difficulty;
  int wateringFrequencySpringToSummerNumber;
  int wateringFrequencyAutumnToWinterNumber;
  String wateringFrequencySpringToSummer;
  String wateringFrequencyAutumnToWinter;
  String exposure;
  bool toxicity;
  String potting;
  DateTime creationDate;
  int ownerId;
  Uint8List picture;

  Plant(
      {this.id,
      this.name,
      this.height,
      this.humidityMax,
      this.humidityMin,
      this.difficulty,
      this.wateringFrequencySpringToSummerNumber,
      this.wateringFrequencyAutumnToWinterNumber,
      this.wateringFrequencySpringToSummer,
      this.wateringFrequencyAutumnToWinter,
      this.exposure,
      this.toxicity,
      this.potting,
      this.creationDate,
      this.ownerId,
      this.picture});

  Plant copyWith(
      {int id,
      String name,
      int height,
      int humidityMax,
      int humidityMin,
      String difficulty,
      int wateringFrequencySpringToSummerNumber,
      int wateringFrequencyAutumnToWinterNumber,
      String wateringFrequencySpringToSummer,
      String wateringFrequencyAutumnToWinter,
      String exposure,
      String toxicity,
      String potting,
      DateTime creationDate,
      int ownerId,
      Uint8List picture,
      int humiditySensor}) {
    return Plant(
        id: id ?? this.id,
        name: name ?? this.name,
        height: height ?? this.height,
        humidityMax: humidityMax ?? this.humidityMax,
        humidityMin: humidityMin ?? this.humidityMin,
        difficulty: difficulty ?? this.difficulty,
        wateringFrequencySpringToSummerNumber:
            wateringFrequencySpringToSummerNumber ??
                this.wateringFrequencySpringToSummerNumber,
        wateringFrequencyAutumnToWinterNumber:
            wateringFrequencyAutumnToWinterNumber ??
                this.wateringFrequencyAutumnToWinterNumber,
        wateringFrequencySpringToSummer: wateringFrequencySpringToSummer ??
            this.wateringFrequencySpringToSummer,
        wateringFrequencyAutumnToWinter: wateringFrequencyAutumnToWinter ??
            this.wateringFrequencyAutumnToWinter,
        exposure: exposure ?? this.exposure,
        toxicity: toxicity ?? this.toxicity,
        potting: potting ?? this.potting,
        creationDate: creationDate ?? this.creationDate,
        ownerId: ownerId ?? this.ownerId,
        picture: picture ?? this.picture);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'height': height,
      'humidityMax': humidityMax,
      'humidityMin': humidityMin,
      'difficulty': difficulty,
      'wateringFrequencySpringToSummerNumber':
          wateringFrequencySpringToSummerNumber,
      'wateringFrequencyAutumnToWinterNumber':
          wateringFrequencyAutumnToWinterNumber,
      'wateringFrequencySpringToSummer': wateringFrequencySpringToSummer,
      'wateringFrequencyAutumnToWinter': wateringFrequencyAutumnToWinter,
      'exposure': exposure,
      'toxicity': toxicity,
      'potting': potting,
      'creationDate': creationDate.toString(),
      'ownerId': ownerId,
      'picture': this.picture != null ? base64Encode(this.picture) : null,
    };
  }

  static Plant fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Plant(
      id: map['id'],
      name: map['name'],
      height: map['height'],
      humidityMax: map['humidityMax'],
      humidityMin: map['humidityMin'],
      difficulty: map['difficulty'],
      wateringFrequencySpringToSummerNumber:
          map['wateringFrequencySpringToSummerNumber'],
      wateringFrequencyAutumnToWinterNumber:
          map['wateringFrequencyAutumnToWinterNumber'],
      wateringFrequencySpringToSummer: map['wateringFrequencySpringToSummer'],
      wateringFrequencyAutumnToWinter: map['wateringFrequencyAutumnToWinter'],
      exposure: map['exposure'],
      toxicity: map['toxicity'],
      potting: map['potting'],
      creationDate: map['creationDate'],
      ownerId: map['ownerId'],
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
    return 'Plant(id: $id, name: $name, height: $height, humidityMax: $humidityMax, humidityMin: $humidityMin, difficulty: $difficulty, wateringFrequencySpringToSummerNumber: $wateringFrequencySpringToSummerNumber, wateringFrequencyAutumnToWinterNumber: $wateringFrequencyAutumnToWinterNumber wateringFrequencySpringToSummer: $wateringFrequencySpringToSummer, wateringFrequencyAutumnToWinter: $wateringFrequencyAutumnToWinter,  exposure: $exposure, toxicity: $toxicity, potting: $potting, creationDate: $creationDate, ownerId: $ownerId)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Plant &&
        o.id == id &&
        o.name == name &&
        o.height == height &&
        o.humidityMax == humidityMax &&
        o.humidityMin == humidityMin &&
        o.difficulty == difficulty &&
        o.wateringFrequencySpringToSummerNumber ==
            wateringFrequencySpringToSummerNumber &&
        o.wateringFrequencyAutumnToWinterNumber ==
            wateringFrequencyAutumnToWinterNumber &&
        o.wateringFrequencySpringToSummer == wateringFrequencySpringToSummer &&
        o.wateringFrequencyAutumnToWinter == wateringFrequencyAutumnToWinter &&
        o.exposure == exposure &&
        o.toxicity == toxicity &&
        o.potting == potting &&
        o.creationDate == creationDate &&
        o.ownerId == ownerId &&
        o.picture == picture;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        height.hashCode ^
        humidityMax.hashCode ^
        humidityMin.hashCode ^
        difficulty.hashCode ^
        wateringFrequencySpringToSummerNumber.hashCode ^
        wateringFrequencyAutumnToWinterNumber.hashCode ^
        wateringFrequencySpringToSummer.hashCode ^
        wateringFrequencyAutumnToWinter.hashCode ^
        exposure.hashCode ^
        toxicity.hashCode ^
        potting.hashCode ^
        creationDate.hashCode ^
        ownerId.hashCode ^
        picture.hashCode;
  }
}
