// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:parkingos/parking/parking_staticits_cars.dart';
import 'package:parkingos/parking/parking_staticits_parking_spots.dart';
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
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      ParkingStatisticsParkingSpotsPage(parking: parking),
      ParkingStatisticsCarsPage(parking: parking)
    ];
    return SafeArea(
      child: Expanded(
        child: SizedBox(
          child: Column(children: [
            Expanded(
                child: Row(
              children: [
                Column(
                  children: [
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 0;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: _selectedIndex == 0
                                ? const Color(0xff156BAD)
                                : const Color(0xff0C3C61),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25),
                                bottomLeft: Radius.circular(25))),
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            'miejsca',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height <
                                      MediaQuery.of(context).size.width
                                  ? MediaQuery.of(context).size.height / 20
                                  : MediaQuery.of(context).size.width / 20,
                              color: _selectedIndex == 0
                                  ? Colors.white
                                  : Colors.white38,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Jaldi',
                              decorationThickness: 3.0,
                            ),
                          ),
                        ),
                      ),
                    )),
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: _selectedIndex == 1
                                ? const Color(0xff156BAD)
                                : const Color(0xff0C3C61),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25),
                                bottomLeft: Radius.circular(25))),
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            'pojazdy',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height <
                                      MediaQuery.of(context).size.width
                                  ? MediaQuery.of(context).size.height / 20
                                  : MediaQuery.of(context).size.width / 20,
                              color: _selectedIndex == 1
                                  ? Colors.white
                                  : Colors.white38,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Jaldi',
                              decorationThickness: 3.0,
                            ),
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(child: tabs[_selectedIndex]),
                    ],
                  ),
                ),
              ],
            )),
          ]),
        ),
      ),
    );
  }
}
