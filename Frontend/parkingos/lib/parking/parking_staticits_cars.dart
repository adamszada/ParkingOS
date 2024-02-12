// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:parkingos/util/parking_lot.dart';

class ParkingStatisticsCarsPage extends StatefulWidget {
  final ParkingLot parking;
  const ParkingStatisticsCarsPage({super.key, required this.parking});

  @override
  ParkingStatisticsCarsPageState createState() =>
      ParkingStatisticsCarsPageState(parking: this.parking);
}

class ParkingStatisticsCarsPageState extends State<ParkingStatisticsCarsPage> {
  final ParkingLot parking;
  ParkingStatisticsCarsPageState({required this.parking});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Color(0xff156BAD),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
              bottomRight: Radius.circular(25))),
    );
  }
}
