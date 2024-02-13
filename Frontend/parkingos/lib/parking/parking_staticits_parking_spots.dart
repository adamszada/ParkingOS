// ignore_for_file: unnecessary_string_interpolations

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:parkingos/parking/util/parking_statistic_item.dart';
import 'package:parkingos/util/parking_lot.dart';
import 'package:parkingos/util/vehicle.dart';
import 'package:http/http.dart' as http;

class ParkingStatisticsParkingSpotsPage extends StatefulWidget {
  final ParkingLot parking;
  const ParkingStatisticsParkingSpotsPage({super.key, required this.parking});

  @override
  ParkingStatisticsParkingSpotsPageState createState() =>
      ParkingStatisticsParkingSpotsPageState(parking: this.parking);
}

class ParkingStatisticsParkingSpotsPageState
    extends State<ParkingStatisticsParkingSpotsPage> {
  final ParkingLot parking;
  ParkingStatisticsParkingSpotsPageState({required this.parking});
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // początkowa wybrana data
      firstDate: DateTime(2000), // początkowa data, którą można wybrać
      lastDate: DateTime(2025), // końcowa data, którą można wybrać
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  List<ParkingStatisticsItem> parkingStatisticsItems = [];

  List<ParkingStatisticsItem> temp = [];

  Future<void> fetchParkingStatistics() async {
    final apiUrl = "http://127.0.0.1:5000/parking_statistics_view/${parking.name}";
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        temp = (data['list'] as List)
            .map((json) => ParkingStatisticsItem.fromJson(json))
            .toList();
      });
    } else {
      throw Exception('Failed to load parking costs');
    }
  }


  @override
  void initState() {
    super.initState();
    fetchParkingStatistics();
  }

  String parkingSpot = "";
  String floor = "";

  List<ParkingStatisticsItem> selectParkingStaticticsItem(
      String parkingSpot, String floor, List<ParkingStatisticsItem> list) {
    List<ParkingStatisticsItem> new_list = [];
    DateTime combinedSelectedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    for (int i = 0; i < list.length; i++) {
      if ((list[i].floor == floor && list[i].parkingSpot == parkingSpot) ||
          (list[i].floor == floor && parkingSpot == "wszystkie miejsca") ||
          (floor == "wszystkie piętra" && list[i].parkingSpot == parkingSpot) ||
          (floor == "wszystkie piętra" && parkingSpot == "wszystkie miejsca")) {
        if (combinedSelectedDateTime.isAfter(list[i].dateStart) &&
            combinedSelectedDateTime.isBefore(list[i].dateEnd))
          new_list.add(list[i]);
      }
    }
    return new_list;
  }

  @override
  Widget build(BuildContext context) {
    List<String> parkingSpotsList = [];
    parkingSpotsList.add("wszystkie miejsca");
    for (int i = 0; i < parking.capacityPerFloor; i++) {
      parkingSpotsList.add("M:${i.toString()}");
    }
    if (parkingSpot == "") parkingSpot = parkingSpotsList.first;

    List<String> floorsList = [];
    floorsList.add("wszystkie piętra");
    for (int i = 0; i < parking.floors; i++) {
      if (i == 0) {
        floorsList.add("parter".toUpperCase());
      } else {
        floorsList.add("${i.toString()}. piętro".toUpperCase());
      }
    }
    if (floor == "") floor = floorsList.first;

    parkingStatisticsItems =
        selectParkingStaticticsItem(parkingSpot, floor, temp);

    return Container(
      decoration: const BoxDecoration(
          color: Color(0xff156BAD),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              topRight: Radius.circular(25),
              bottomRight: Radius.circular(25))),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "data:",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height <
                                    MediaQuery.of(context).size.width
                                ? MediaQuery.of(context).size.height / 40
                                : MediaQuery.of(context).size.width / 40,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Jaldi',
                            decorationThickness: 3.0,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _selectDate(context),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    "${selectedDate.day}.${selectedDate.month < 10 ? "0${selectedDate.month}" : selectedDate.month}.${selectedDate.year}r.",
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height <
                                              MediaQuery.of(context).size.width
                                          ? MediaQuery.of(context).size.height /
                                              40
                                          : MediaQuery.of(context).size.width /
                                              40,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w100,
                                      fontFamily: 'Jaldi',
                                      decorationThickness: 3.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "godzina:",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height <
                                    MediaQuery.of(context).size.width
                                ? MediaQuery.of(context).size.height / 40
                                : MediaQuery.of(context).size.width / 40,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Jaldi',
                            decorationThickness: 3.0,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _selectTime(context),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    "${selectedTime.hour}:${selectedTime.minute >= 10 ? "${selectedTime.minute}" : "0${selectedTime.minute}"}",
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height <
                                              MediaQuery.of(context).size.width
                                          ? MediaQuery.of(context).size.height /
                                              40
                                          : MediaQuery.of(context).size.width /
                                              40,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w100,
                                      fontFamily: 'Jaldi',
                                      decorationThickness: 3.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "piętro:",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height <
                                    MediaQuery.of(context).size.width
                                ? MediaQuery.of(context).size.height / 40
                                : MediaQuery.of(context).size.width / 40,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Jaldi',
                            decorationThickness: 3.0,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: DropdownButton<String>(
                                    value: floor,
                                    borderRadius: BorderRadius.circular(25),
                                    underline: Container(),
                                    isExpanded: true,
                                    menuMaxHeight:
                                        (MediaQuery.of(context).size.height ~/
                                                3)
                                            .toDouble(),
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height <
                                              MediaQuery.of(context).size.width
                                          ? MediaQuery.of(context).size.height /
                                              40
                                          : MediaQuery.of(context).size.width /
                                              40,
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
                                    items: floorsList
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
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "miejsce:",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height <
                                    MediaQuery.of(context).size.width
                                ? MediaQuery.of(context).size.height / 40
                                : MediaQuery.of(context).size.width / 40,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Jaldi',
                            decorationThickness: 3.0,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: DropdownButton<String>(
                                    value: parkingSpot,
                                    borderRadius: BorderRadius.circular(25),
                                    underline: Container(),
                                    isExpanded: true,
                                    menuMaxHeight:
                                        (MediaQuery.of(context).size.height ~/
                                                3)
                                            .toDouble(),
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height <
                                              MediaQuery.of(context).size.width
                                          ? MediaQuery.of(context).size.height /
                                              40
                                          : MediaQuery.of(context).size.width /
                                              40,
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
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5),
              child: Row(
                children: [
                  Expanded(child: Container(height: 5, color: Colors.white))
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(25)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "suma zarobków:",
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height <
                                          MediaQuery.of(context).size.width
                                      ? MediaQuery.of(context).size.height / 25
                                      : MediaQuery.of(context).size.width / 25,
                                  color: const Color(0xff0C3C61),
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Jaldi',
                                  height: 1),
                            ),
                            Text(
                              "${parking.totalEarnings} zł",
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height <
                                          MediaQuery.of(context).size.width
                                      ? MediaQuery.of(context).size.height / 25
                                      : MediaQuery.of(context).size.width / 25,
                                  color: const Color(0xff0C3C61),
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Jaldi',
                                  height: 1),
                            ),
                          ],
                        ),
                      )),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(25)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "zarobek na godzine:",
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height <
                                          MediaQuery.of(context).size.width
                                      ? MediaQuery.of(context).size.height / 25
                                      : MediaQuery.of(context).size.width / 25,
                                  color: const Color(0xff0C3C61),
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Jaldi',
                                  height: 1),
                            ),
                            Text(
                              "${parking.curEarnings} zł/h",
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height <
                                          MediaQuery.of(context).size.width
                                      ? MediaQuery.of(context).size.height / 25
                                      : MediaQuery.of(context).size.width / 25,
                                  color: const Color(0xff0C3C61),
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Jaldi',
                                  height: 1),
                            ),
                          ],
                        ),
                      )),
                )),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 5, right: 5),
                child: Row(children: [
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return buildparkingStatisticsItems(index);
                      },
                      itemCount: parkingStatisticsItems.length,
                      scrollDirection: Axis.vertical,
                    ),
                  ),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildparkingStatisticsItems(int index) {
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
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${parkingStatisticsItems[index].floor} | ${parkingStatisticsItems[index].parkingSpot}",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height / 40),
                      ),
                      Expanded(
                        child: Text(
                          "${parkingStatisticsItems[index].vehicle.model} | ${parkingStatisticsItems[index].vehicle.brand} | ${parkingStatisticsItems[index].vehicle.registration}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height / 40),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "od: ${parkingStatisticsItems[index].dateStart.toString().substring(0, 16)} do: ${parkingStatisticsItems[index].dateEnd.toString().substring(0, 16)}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height / 40),
                        ),
                      ),
                      Text(
                        "${parkingStatisticsItems[index].curEarnings} zł",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height / 40),
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
