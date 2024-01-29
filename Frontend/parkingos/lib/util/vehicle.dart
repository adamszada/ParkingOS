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
}
