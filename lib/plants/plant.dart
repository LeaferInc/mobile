class Plant {
  String name;
  int humidity;
  String watering;
  int difficulty;
  String exposure;
  String toxicity;
  String potting;
  String creationDate;

  Plant(String name, int humidity, String watering, int difficulty,
      String exposure, String toxicity, String potting, String creationDate) {
    this.name = name;
    this.humidity = humidity;
    this.watering = watering;
    this.difficulty = difficulty;
    this.exposure = exposure;
    this.toxicity = toxicity;
    this.potting = potting;
    this.creationDate = creationDate;
  }
}
