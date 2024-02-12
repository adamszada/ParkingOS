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
}