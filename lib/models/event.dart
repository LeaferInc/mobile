/// This class represents an Event
class Event {
  int id;
  String name;
  String description;
  String location;
  DateTime startDate;
  DateTime endDate;
  double price;
  int maxPeople;
  double latitude;
  double longitude;

  Event(
      {this.id,
      this.name,
      this.description,
      this.location,
      this.startDate,
      this.endDate,
      this.price,
      this.maxPeople,
      this.latitude,
      this.longitude});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      price: json['price'].toDouble(),
      maxPeople: json['maxPeople'] as int,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'location': location,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'price': price,
        'maxPeople': maxPeople,
        'latitude': latitude,
        'longitude': longitude,
      };

  @override
  String toString() {
    return '{\n\tname: $name,\n\tdescription: $description,\n'
        '\tlocation: $location,\n\tstartDate: $startDate,\n\tendDate: $endDate,\n'
        '\tprice: $price,\n\tmaxPeople: $maxPeople,\n'
        '\tcoordinates: ($latitude, $longitude)\n}';
  }
}
