class Entrant {
  int id;
  String username;
  String firstname;
  String lastname;

  Entrant({this.id, this.username, this.firstname, this.lastname});

  factory Entrant.fromMap(Map<String, dynamic> map) {
    return new Entrant(
      id: map['id'] as int,
      username: map['username'] as String,
      firstname: map['firstname'] as String,
      lastname: map['lastname'] as String,
    );
  }

  @override
  String toString() {
    return '{\n\tid: $id,\n\tusername: $username\n'
        '\tfirstame: $firstname,\n\tlastname: $lastname\n}';
  }
}
