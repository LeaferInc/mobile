import 'dart:convert';
import 'dart:typed_data';

/// Result object
class RecognitionResult {
  double score;
  String name;

  RecognitionResult({
    this.score,
    this.name,
  });

  /// Returns a percentage with 2 decimals max
  String getScoreRate() {
    return this.score.toStringAsFixed(2);
  }

  factory RecognitionResult.fromMap(Map<String, dynamic> map) {
    return new RecognitionResult(
      score: map['score'] as double,
      name: map['name'] as String,
    );
  }
}

/// Search object
class RecognitionSearch {
  String organ = 'leaf';
  Uint8List image;

  RecognitionSearch(this.image);

  Map<String, dynamic> toJson() {
    return {
      'organ': this.organ,
      'image': base64Encode(this.image),
    };
  }
}
