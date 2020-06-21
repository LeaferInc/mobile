import 'dart:convert';

class Plant {
  String name;
  int humidity;
  String watering;
  int difficulty;
  String exposure;
  String toxicity;
  String potting;
  DateTime creationDate;
  String image;

  Plant({
    this.name,
    this.humidity,
    this.watering,
    this.difficulty,
    this.exposure,
    this.toxicity,
    this.potting,
    this.creationDate,
    this.image,
  });

  Plant copyWith({
    String name,
    int humidity,
    String watering,
    int difficulty,
    String exposure,
    String toxicity,
    String potting,
    DateTime creationDate,
    String image,
  }) {
    return Plant(
      name: name ?? this.name,
      humidity: humidity ?? this.humidity,
      watering: watering ?? this.watering,
      difficulty: difficulty ?? this.difficulty,
      exposure: exposure ?? this.exposure,
      toxicity: toxicity ?? this.toxicity,
      potting: potting ?? this.potting,
      creationDate: creationDate ?? this.creationDate,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'humidity': humidity,
      'watering': watering,
      'difficulty': difficulty,
      'exposure': exposure,
      'toxicity': toxicity,
      'potting': potting,
      'creationDate': creationDate.toString(),
      'image': image,
    };
  }

  static Plant fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Plant(
      name: map['name'],
      humidity: map['humidity'],
      watering: map['watering'],
      difficulty: map['difficulty'],
      exposure: map['exposure'],
      toxicity: map['toxicity'],
      potting: map['potting'],
      creationDate: map['creationDate'],
      image: map['image'],
    );
  }

  // String toJson() => json.encode(toMap());

  static Plant fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Plant(name: $name, humidity: $humidity, watering: $watering, difficulty: $difficulty, exposure: $exposure, toxicity: $toxicity, potting: $potting, creationDate: $creationDate, image: $image)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Plant &&
        o.name == name &&
        o.humidity == humidity &&
        o.watering == watering &&
        o.difficulty == difficulty &&
        o.exposure == exposure &&
        o.toxicity == toxicity &&
        o.potting == potting &&
        o.creationDate == creationDate &&
        o.image == image;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        humidity.hashCode ^
        watering.hashCode ^
        difficulty.hashCode ^
        exposure.hashCode ^
        toxicity.hashCode ^
        potting.hashCode ^
        creationDate.hashCode ^
        image.hashCode;
  }
}
