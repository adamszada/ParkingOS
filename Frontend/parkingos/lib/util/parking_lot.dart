class ParkingLot {
  String name;
  String address;
  int capacity;
  int currentOccupancy;
  double totalEarnings;
  double curEarnings;
  double earningsToday;
  double dayTariff;
  double nightTariff;
  late String operatingHours;

  ParkingLot(
      {required this.name,
      required this.address,
      required this.capacity,
      this.currentOccupancy = 0,
      this.totalEarnings = 0.0,
      this.earningsToday = 0.0,
      this.curEarnings = 0.0,
      required this.dayTariff,
      required this.nightTariff});

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

  @override
  String toString() {
    return 'ParkingLot{name: $name, address: $address, capacity: $capacity, currentOccupancy: $currentOccupancy, totalEarnings: $totalEarnings, earningsToday: $earningsToday}';
  }
}
