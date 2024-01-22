class Vehicle {
  String registration;
  String model;
  String brand;

  Vehicle(
      {required this.registration, required this.model, required this.brand});

  @override
  String toString() {
    return 'Vehicle{registration: $registration, model: $model, brand: $brand}';
  }
}
