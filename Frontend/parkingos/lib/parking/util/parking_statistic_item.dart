import 'package:parkingos/util/vehicle.dart';

class ParkingStatisticsItem {
  late String floor = "";
  late String parkingSpot = "";
  late Vehicle vehicle;
  late DateTime dateStart;
  late DateTime dateEnd;
  late double curEarnings = 0;

  ParkingStatisticsItem(
      {required this.floor,
      required this.parkingSpot,
      required this.vehicle,
      required this.dateStart,
      required this.dateEnd,
      required this.curEarnings});

  factory ParkingStatisticsItem.fromJson(Map<String, dynamic> json) {
    return ParkingStatisticsItem(
      floor: floorParser(json['floor'].toString()).toUpperCase(),
      parkingSpot: "M:${json['parkingSpot'].toString()}".toUpperCase(),
      vehicle: Vehicle.fromString(json['vehicle']),
      dateEnd: DateTime.parse(json['dateEnd'].toString().split(".").first),
      dateStart: DateTime.parse(json['dateStart'].toString().split(".").first),
      curEarnings: json['earning'],
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