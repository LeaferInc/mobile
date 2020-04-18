class Event {
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
      {this.name,
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
      name: json['name'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      // Cast as double because it casts itself as int
      price: json['price'].toDouble(),
      maxPeople: json['maxPeople'] as int,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
    );
  }

  @override
  String toString() {
    return '{\n\tname: $name,\n\tdescription: $description,\n'
        '\tlocation: $location,\n\tstartDate: $startDate,\n\tendDate: $endDate,\n'
        '\tprice: $price,\n\tmaxPeople: $maxPeople,\n'
        '\tcoordinates: ($latitude, $longitude)\n}';
  }
}
