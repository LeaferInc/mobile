/// This class represents an Event
/// @author ddaninthe
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

  Event({
    this.id,
    this.name,
    this.description,
    this.location,
    this.startDate,
    this.endDate,
    this.price,
    this.maxPeople,
    this.latitude,
    this.longitude,
  });

  /// Used to create a new Event
  Map<String, dynamic> toJson() {
    return {
      'name': this.name,
      'description': this.description,
      'location': this.location,
      'startDate': this.startDate.toIso8601String(),
      'endDate': this.endDate.toIso8601String(),
      'price': this.price,
      'maxPeople': this.maxPeople,
      'latitude': this.latitude,
      'longitude': this.longitude,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return new Event(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String,
      location: map['location'] as String,
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      price: map['price'].toDouble(),
      maxPeople: map['maxPeople'] as int,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
    );
  }

  @override
  String toString() {
    return '{\n\tid: $id,\n'
        '\tname: $name,\n\tdescription: $description,\n'
        '\tlocation: $location,\n\tstartDate: $startDate,\n'
        '\tendDate: $endDate,\n\tprice: $price,\n\tmaxPeople: $maxPeople,\n'
        '\tcoordinates: ($latitude, $longitude)\n}';
  }
}
