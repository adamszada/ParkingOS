// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:parkingos/util/parking_cost.dart';
import 'package:parkingos/util/parking_lot.dart';

class ParkingLiveViewPage extends StatefulWidget {
  final ParkingLot parking;
  const ParkingLiveViewPage({super.key, required this.parking});

  @override
  ParkingLiveViewPageState createState() =>
      ParkingLiveViewPageState(parking: this.parking);
}

class ParkingLiveViewPageState extends State<ParkingLiveViewPage> {
  final ParkingLot parking;
  ParkingLiveViewPageState({required this.parking});
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return SafeArea(
      child: Expanded(
        child: SizedBox(
          child: Column(children: [
            Row(
              children: [
                Expanded(
                    child: Text(
                  "${now.day}.${now.month < 10 ? "0${now.month}" : now.month}.${now.year}r. ${now.hour}:${now.minute > 10 ? "${now.minute}" : "0${now.minute}"}",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height <
                              MediaQuery.of(context).size.width
                          ? MediaQuery.of(context).size.height / 17
                          : MediaQuery.of(context).size.width / 17,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Jaldi'),
                ))
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50)),
                      height: MediaQuery.of(context).size.height / 128,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 9.0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Expanded(
                        child: Container(
                          height: MediaQuery.of(context).size.height / 7,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "zarobki dzisiaj",
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height <
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  15
                                              : MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  15,
                                          color: const Color(0xff0C3C61),
                                          fontWeight: FontWeight.w900,
                                          fontFamily: 'Jaldi',
                                          height: 1),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${parking.earningsToday.toStringAsFixed(2)}zł",
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height <
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  12
                                              : MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  12,
                                          color: const Color(0xff0C3C61),
                                          fontWeight: FontWeight.w900,
                                          fontFamily: 'Jaldi',
                                          height: 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Expanded(
                        child: Container(
                          height: MediaQuery.of(context).size.height / 7,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "zarobki chwilowe",
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height <
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  15
                                              : MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  15,
                                          color: const Color(0xff0C3C61),
                                          fontWeight: FontWeight.w900,
                                          fontFamily: 'Jaldi',
                                          height: 1),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${parking.curEarnings.toStringAsFixed(2)}zł",
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height <
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  12
                                              : MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  12,
                                          color: const Color(0xff0C3C61),
                                          fontWeight: FontWeight.w900,
                                          fontFamily: 'Jaldi',
                                          height: 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Expanded(
                        child: Container(
                          height: MediaQuery.of(context).size.height / 7,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "miejsca",
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height <
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  13
                                              : MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  13,
                                          color: const Color(0xff0C3C61),
                                          fontWeight: FontWeight.w900,
                                          fontFamily: 'Jaldi',
                                          height: 1),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${parking.currentOccupancy}/${parking.capacity}",
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height <
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  12
                                              : MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  12,
                                          color: const Color(0xff0C3C61),
                                          fontWeight: FontWeight.w900,
                                          fontFamily: 'Jaldi',
                                          height: 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 20, right: 25),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "piętro/miejsce:",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height / 48),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "pojazd:",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height / 48),
                    ),
                  ),
                  // Expanded(
                  //     child: Row(
                  //   children: [
                  //     Expanded(
                  //       child: Text(
                  //         "z.dzienny:",
                  //         style: TextStyle(
                  //             color: Colors.white,
                  //             fontWeight: FontWeight.bold,
                  //             fontSize:
                  //                 MediaQuery.of(context).size.height / 48),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Text(
                  //         "z.chwilowy:",
                  //         style: TextStyle(
                  //             color: Colors.white,
                  //             fontWeight: FontWeight.bold,
                  //             fontSize:
                  //                 MediaQuery.of(context).size.height / 48),
                  //       ),
                  //     ),
                  //   ],
                  // ))
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return buildParkingCostItem(index);
                },
                itemCount: 100,
                scrollDirection: Axis.vertical,
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget buildParkingCostItem(int index) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                child: Row(children: [
                  Expanded(
                    child: Text(
                      "P: ${index} | M: ${index}",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 40),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "${index % 2 == 1 ? "RENAULT | CLIO | ETM CU48" : "- - - - -"}",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 40),
                    ),
                  ),
                  // Expanded(
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: Text(
                  //           "123 zł",
                  //           style: TextStyle(
                  //               fontSize:
                  //                   MediaQuery.of(context).size.height / 40),
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: Text(
                  //           "10 zł",
                  //           style: TextStyle(
                  //               fontSize:
                  //                   MediaQuery.of(context).size.height / 40),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
