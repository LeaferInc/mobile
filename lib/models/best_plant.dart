import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:leafer/models/image_model.dart';

/// Result object
class BestPlant implements IImageModel {
  String name;
  String careTime;
  String height;
  int price;
  String luminosity;
  int potting;
  bool toxicity;
  Uint8List picture;

  BestPlant({
    this.name,
    this.careTime,
    this.potting,
    this.toxicity,
    this.price,
    this.luminosity,
    this.height,
    this.picture,
  });

  factory BestPlant.fromMap(Map<String, dynamic> map) {
    return new BestPlant(
      name: map['name'] as String,
      careTime: map['careTime'] as String,
      height: map['height'] as String,
      luminosity: map['luminosity'] as String,
      potting: map['potting'] as int,
      toxicity: map['toxicity'] as bool,
      price: map['price'] as int,
      picture: base64Decode(map['picture']),
    );
  }

  @override
  ImageProvider getPicture() {
    return MemoryImage(this.picture);
  }
}

/// Search object
class BestPlantSearch {
  String careTime;
  String weather;
  bool space;
  int budget;
  bool hasPet;

  BestPlantSearch({
    this.careTime,
    this.weather,
    this.space,
    this.budget,
    this.hasPet,
  });

  Map<String, dynamic> toJson() {
    return {
      'careTime': this.careTime.toLowerCase(),
      'weather': this.weather.toLowerCase(),
      'space': this.space,
      'budget': this.budget,
      'hasPet': this.hasPet,
    };
  }
}
