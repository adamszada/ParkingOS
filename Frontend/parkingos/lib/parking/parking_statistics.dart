// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:parkingos/util/parking_lot.dart';

class ParkingStatisticsPage extends StatefulWidget {
  final ParkingLot parking;
  const ParkingStatisticsPage({super.key, required this.parking});

  @override
  ParkingStatisticsPageState createState() =>
      ParkingStatisticsPageState(parking: this.parking);
}

class ParkingStatisticsPageState extends State<ParkingStatisticsPage> {
  final ParkingLot parking;
  ParkingStatisticsPageState({required this.parking});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Expanded(
        child: SizedBox(
          child: Column(children: [
            Expanded(
                child: Container(
              color: Colors.red,
            ))
          ]),
        ),
      ),
    );
  }
}
