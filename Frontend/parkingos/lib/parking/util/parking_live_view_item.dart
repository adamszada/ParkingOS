import 'package:parkingos/util/vehicle.dart';

class ParkingLiveViewItem {
  late String floor = "";
  late String parkingSpot = "";
  late Vehicle vehicle;
  late DateTime dateEnd;
  late double earning = 0;
  ParkingLiveViewItem(
      {required this.floor,
      required this.parkingSpot,
      required this.vehicle,
      required this.dateEnd,
      required this.earning});
  factory ParkingLiveViewItem.fromJson(Map<String, dynamic> json) {
    return ParkingLiveViewItem(
      floor: floorParser(json['floor'].toString()).toUpperCase(),
      parkingSpot: "M:${json['parkingSpot'].toString()}".toUpperCase(),
      vehicle: Vehicle.fromString(json['vehicle']),
      dateEnd: DateTime.parse(json['dateEnd'].toString().split(".").first),
      earning: json['earning'],
    );
  }
}

String floorParser(String s) {
  String result = "";
  int num = int.parse(s) - 1;
  if (num == 0) return "parter";
  result = "${num}. pięro";
  return result;
}
