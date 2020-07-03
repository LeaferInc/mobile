class Location {
  String label;
  String city;
  double latitude;
  double longitude;

  Location({this.label, this.city, this.latitude, this.longitude});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
        label: json['properties']['label'] as String,
        city: json['properties']['city'] as String,
        latitude: json['geometry']['coordinates'][1].toDouble(),
        longitude: json['geometry']['coordinates'][0].toDouble());
  }

  @override
  String toString() {
    return '$label ($latitude, $longitude)';
  }
}
