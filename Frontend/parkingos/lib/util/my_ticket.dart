class MyTicket {
  late String userID;
  late String registration;
  late String carName;
  late DateTime parkTime;
  late DateTime entryDate;
  late String parkingAddress;
  late int parkingSpotNumber;
  late int floor;
  late double moneyDue;
  late String qrCode;
  late String parkingId;

  MyTicket({
    this.userID = "",
    required this.registration,
    required this.carName,
    required this.entryDate,
    required this.parkTime,
    required this.parkingAddress,
    required this.parkingSpotNumber,
    required this.floor,
    required this.moneyDue,
    required this.qrCode,
    required this.parkingId,
  });

MyTicket.fromJson(Map<String, dynamic> json) {
  registration = json['registration'] ?? '';
  carName = json['carName'] ?? '';
  // Safely parsing DateTime, considering invalid or null input
  String? dateTimeStr = json['parkTime'];
  parkTime = dateTimeStr != null ? DateTime.tryParse(dateTimeStr) ?? DateTime.now() : DateTime.now();
  parkingAddress = json['parkingAddress'] ?? '';
  // Safely converting to int, considering string inputs
  parkingSpotNumber = int.tryParse(json['parkingSpotNumber'].toString()) ?? 0;
  floor = int.tryParse(json['floor'].toString()) ?? 0;
  // Safely converting to double, considering string inputs
  moneyDue = double.tryParse(json['moneyDue'].toString()) ?? 0.0;
  qrCode = json['qrCode'] ?? '';
  parkingId = json['parkingId'] ?? '';
}

  @override
  String toString() {
    return 'MyTicket{registration: $registration, carName: $carName, parkTime: $parkTime, parkingAddress: $parkingAddress, parkingSpotNumber: $parkingSpotNumber, floor: $floor, moneyDue: $moneyDue, qrCode: $qrCode, parkingId: $parkingId}';
  }
}