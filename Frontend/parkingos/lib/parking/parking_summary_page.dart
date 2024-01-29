// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:parkingos/util/parking_cost.dart';
import 'package:parkingos/util/parking_lot.dart';

class ParkingSummaryPage extends StatefulWidget {
  final ParkingLot parking;
  const ParkingSummaryPage({super.key, required this.parking});

  @override
  ParkingSummaryPageState createState() =>
      ParkingSummaryPageState(parking: this.parking);
}

class ParkingSummaryPageState extends State<ParkingSummaryPage> {
  final ParkingLot parking;
  ParkingSummaryPageState({required this.parking});
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
