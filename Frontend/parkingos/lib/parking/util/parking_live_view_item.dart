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
}
