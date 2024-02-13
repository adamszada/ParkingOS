// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:parkingos/parking/util/parking_live_view_item.dart';
import 'package:parkingos/util/parking_cost.dart';
import 'package:parkingos/util/parking_lot.dart';
import 'package:parkingos/util/vehicle.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  String parkingSpot = "";
  String floor = "";

  List<ParkingLiveViewItem> temp = [];
  Future<void> fetchParkingCosts() async {
    final apiUrl = "http://127.0.0.1:5000/parking_live_view/${parking.name}";
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        temp = (data['list'] as List)
            .map((json) => ParkingLiveViewItem.fromJson(json))
            .toList();
      });
    } else {
      throw Exception('Failed to load parking costs');
    }
  }

  // temp = [
  //   ParkingLiveViewItem(
  //       floor: "1. piętro",
  //       parkingSpot: "M:0",
  //       vehicle: Vehicle(
  //           brand: "BRAND", model: "MODEL", registration: "REGISTRATION"),
  //       dateEnd: DateTime(2024, 2, 13, 16, 28),
  //       earning: 0),
  //   ParkingLiveViewItem(
  //       floor: "1. piętro",
  //       parkingSpot: "M:1",
  //       vehicle: Vehicle(
  //           brand: "BRAND", model: "MODEL", registration: "REGISTRATION"),
  //       dateEnd: DateTime(2024, 2, 13, 16, 28),
  //       earning: 0),
  //   ParkingLiveViewItem(
  //       floor: "1. piętro",
  //       parkingSpot: "M:2",
  //       vehicle: Vehicle(
  //           brand: "BRAND", model: "MODEL", registration: "REGISTRATION"),
  //       dateEnd: DateTime(2024, 2, 13, 16, 28),
  //       earning: 0),
  //   ParkingLiveViewItem(
  //       floor: "1. piętro",
  //       parkingSpot: "M:3",
  //       vehicle: Vehicle(
  //           brand: "BRAND", model: "MODEL", registration: "REGISTRATION"),
  //       dateEnd: DateTime(2023, 2, 13, 16, 28),
  //       earning: 100),
  //   ParkingLiveViewItem(
  //       floor: "2. piętro",
  //       parkingSpot: "M:0",
  //       vehicle: Vehicle(
  //           brand: "BRAND", model: "MODEL", registration: "REGISTRATION"),
  //       dateEnd: DateTime(2024, 2, 13, 16, 28),
  //       earning: 100)
  // ];

  List<ParkingLiveViewItem> parkingLiveViewItemList = [];

  List<ParkingLiveViewItem> selectItem(List<ParkingLiveViewItem> list) {
    List<ParkingLiveViewItem> newList = [];
    for (int i = 0; i < list.length; i++) {
      if ((list[i].floor == floor && list[i].parkingSpot == parkingSpot) ||
          (list[i].floor == floor && parkingSpot == "wszystkie miejsca") ||
          (floor == "wszystkie piętra" && list[i].parkingSpot == parkingSpot) ||
          (floor == "wszystkie piętra" && parkingSpot == "wszystkie miejsca")) {
        newList.add(list[i]);
      }
    }
    return newList;
  }

  @override
  void initState() {
    super.initState();
    fetchParkingCosts();
  }

  @override
  Widget build(BuildContext context) {
    List<String> parkingSpotsList = [];
    parkingSpotsList.add("wszystkie miejsca");
    for (int i = 0; i < parking.capacityPerFloor; i++) {
      parkingSpotsList.add("M:${(i + 1).toString()}");
    }
    if (parkingSpot == "") parkingSpot = parkingSpotsList.first;

    List<String> floorsList = [];
    floorsList.add("wszystkie piętra");
    for (int i = 0; i < parking.floors; i++) {
      if (i == 0) {
        floorsList.add("parter");
      } else {
        floorsList.add("${i.toString()}. piętro");
      }
    }
    if (floor == "") floor = floorsList.first;
    DateTime now = DateTime.now();

    parkingLiveViewItemList = selectItem(temp);

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
                )),
                Expanded(
                    child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25)),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: DropdownButton<String>(
                              value: floor,
                              borderRadius: BorderRadius.circular(25),
                              underline: Container(),
                              isExpanded: true,
                              menuMaxHeight:
                                  (MediaQuery.of(context).size.height ~/ 3)
                                      .toDouble(),
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.height <
                                        MediaQuery.of(context).size.width
                                    ? MediaQuery.of(context).size.height / 40
                                    : MediaQuery.of(context).size.width / 40,
                                color: Colors.black,
                                fontWeight: FontWeight.w100,
                                fontFamily: 'Jaldi',
                                decorationThickness: 3.0,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  floor = newValue!;
                                });
                              },
                              items: floorsList.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25)),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: DropdownButton<String>(
                              value: parkingSpot,
                              borderRadius: BorderRadius.circular(25),
                              underline: Container(),
                              isExpanded: true,
                              menuMaxHeight:
                                  (MediaQuery.of(context).size.height ~/ 3)
                                      .toDouble(),
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.height <
                                        MediaQuery.of(context).size.width
                                    ? MediaQuery.of(context).size.height / 40
                                    : MediaQuery.of(context).size.width / 40,
                                color: Colors.black,
                                fontWeight: FontWeight.w100,
                                fontFamily: 'Jaldi',
                                decorationThickness: 3.0,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  parkingSpot = newValue!;
                                });
                              },
                              items: parkingSpotsList
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
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
                  return buildListViewItem(index);
                },
                itemCount: parkingLiveViewItemList.length,
                scrollDirection: Axis.vertical,
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget buildListViewItem(int index) {
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
                  Text(
                    "${parkingLiveViewItemList[index].floor} | ${parkingLiveViewItemList[index].parkingSpot}",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 40),
                  ),
                  Expanded(
                    child: Text(
                      "${parkingLiveViewItemList[index].vehicle.model} | ${parkingLiveViewItemList[index].vehicle.brand} | ${parkingLiveViewItemList[index].vehicle.registration}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 40),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "do: ${parkingLiveViewItemList[index].dateEnd.toString().substring(0, 16)}       ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 40),
                    ),
                  ),
                  Text(
                    "        ${parkingLiveViewItemList[index].earning.toString()} zł",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 40),
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
