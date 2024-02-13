class Vehicle {
  late String registration;
  late String model;
  late String brand;

  Vehicle(
      {required this.registration, required this.model, required this.brand});

  @override
  String toString() {
    return 'Vehicle{registration: $registration, model: $model, brand: $brand}';
  }

  Vehicle.fromJson(Map<String, dynamic> json) {
    registration = json['registration'] ?? '';
    model = json['model'] ?? '';
    brand = json['brand'] ?? '';
  }

  factory Vehicle.fromString(String s) {
    var parts = s.split(' | ');
    if (parts.length != 3) {
      throw FormatException('Invalid input string format');
    }
    return Vehicle(
      brand: parts[1].toUpperCase(),
      model: parts[0].toUpperCase(),
      registration: parts[2].toUpperCase(),
    );
  }
}
