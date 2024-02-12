class ParkingLot {
  late String id;
  late String name;
  late String address;
  late int capacity;
  late int currentOccupancy;
  late double totalEarnings;
  late double curEarnings;
  late double earningsToday;
  late double dayTariff;
  late double nightTariff;
  late String operatingHours;
  late int floors = 3;

  ParkingLot(
      {this.id = '',
      required this.name,
      required this.address,
      required this.capacity,
      this.currentOccupancy = 0,
      this.floors = 3,
      this.totalEarnings = 0.0,
      this.earningsToday = 0.0,
      this.curEarnings = 0.0,
      required this.dayTariff,
      required this.nightTariff,
      required this.operatingHours});

  void updateOccupancy(int occupiedSpaces) {
    currentOccupancy = occupiedSpaces;
  }

  void updateEarnings(double earnings) {
    totalEarnings += earnings;
    earningsToday += earnings;
  }

  void resetDailyEarnings() {
    earningsToday = 0.0;
  }

  ParkingLot.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    address = json['address'] ?? '';
    capacity = json['capacity'] ?? 0;
    currentOccupancy = json['currentOccupancy'] ?? 0;
    totalEarnings = json['totalEarnings'] ?? 0.0;
    earningsToday = json['earningsToday'] ?? 0.0;
    curEarnings = json['curEarnings'] ?? 0.0;
    dayTariff = json['dayTariff'] ?? 0.0;
    nightTariff = json['nightTariff'] ?? 0.0;
    operatingHours = json['operatingHours'] ?? '';
  }

  @override
  String toString() {
    return 'ParkingLot{id: $id, name: $name, address: $address, capacity: $capacity, currentOccupancy: $currentOccupancy, totalEarnings: $totalEarnings, earningsToday: $earningsToday}';
  }
}
