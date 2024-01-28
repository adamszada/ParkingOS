class MyTicket {
  String registration;
  String carName;  // Added carName attribute
  DateTime parkTime;
  String parkingAddress;
  int parkingSpotNumber;
  int floor;
  double moneyDue;
  String qrCode;

  MyTicket({
    required this.registration,
    required this.carName,  // Include carName in the constructor
    required this.parkTime,
    required this.parkingAddress,
    required this.parkingSpotNumber,
    required this.floor,
    required this.moneyDue,
    required this.qrCode,
  });

  @override
  String toString() {
    return 'MyTicket{registration: $registration, carName: $carName, parkTime: $parkTime, parkingAddress: $parkingAddress, parkingSpotNumber: $parkingSpotNumber, floor: $floor, moneyDue: $moneyDue, qrCode: $qrCode}';
  }
}
