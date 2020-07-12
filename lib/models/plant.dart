import 'dart:convert';

class Plant {
  int id;
  String name;
  int height;
  String humidity;
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
  String image;

  Plant(
      {this.id,
      this.name,
      this.height,
      this.humidity,
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
      this.image});

  Plant copyWith(
      {int id,
      String name,
      int height,
      String humidity,
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
      String image,
      int humiditySensor}) {
    return Plant(
        id: id ?? this.id,
        name: name ?? this.name,
        height: height ?? this.height,
        humidity: humidity ?? this.humidity,
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
        image: image ?? this.image);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'height': height,
      'humidity': humidity,
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
      'image': image,
    };
  }

  static Plant fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Plant(
      id: map['id'],
      name: map['name'],
      height: map['height'],
      humidity: map['humidity'],
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
      image: map['image'],
    );
  }

  // String toJson() => json.encode(toMap());

  static Plant fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Plant(id: $id, name: $name, height: $height, humidity: $humidity, difficulty: $difficulty, wateringFrequencySpringToSummerNumber: $wateringFrequencySpringToSummerNumber, wateringFrequencyAutumnToWinterNumber: $wateringFrequencyAutumnToWinterNumber wateringFrequencySpringToSummer: $wateringFrequencySpringToSummer, wateringFrequencyAutumnToWinter: $wateringFrequencyAutumnToWinter,  exposure: $exposure, toxicity: $toxicity, potting: $potting, creationDate: $creationDate, ownerId: $ownerId, image: $image)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Plant &&
        o.id == id &&
        o.name == name &&
        o.height == height &&
        o.humidity == humidity &&
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
        o.image == image;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        height.hashCode ^
        humidity.hashCode ^
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
        image.hashCode;
  }
}
