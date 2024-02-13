import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:parkingos/util/parking_lot.dart';
import 'package:http/http.dart' as http;

class ParkingsScreen extends StatefulWidget {
  const ParkingsScreen({super.key});

  @override
  _ParkingsScreenState createState() => _ParkingsScreenState();
}

Future<void> deleteparking(String id) async {
  var url = Uri.parse('http://127.0.0.1:5000/delete_parking/$id');
  print(id);
  try {
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      print('Car deleted successfully');
    } else if (response.statusCode == 404) {
      print('Car not found');
    } else {
      print('Error: ${response.body}');
    }
  } catch (e) {
    print('Error sending request: $e');
  }
}

Future<List<ParkingLot>> getAllParkings() async {
  var url = Uri.parse("http://127.0.0.1:5000/get_parking_lots");
  final response =
      await http.get(url, headers: {"Content-Type": "application/json"});
  if (response.statusCode == 200) {
    final Map<String, dynamic>? data = json.decode(response.body);
    if (data != null && data.containsKey('parkingLots')) {
      final List<dynamic> parkingList = data['parkingLots'];
      return parkingList.map((e) => ParkingLot.fromJson(e)).toList();
    } else {
      // Handle missing or invalid JSON data
      throw Exception('Invalid JSON data');
    }
  } else {
    // Handle error or return an empty list
    throw Exception('Failed to load vehicles');
  }
}

  double sumEarningsToday = 0;
  double sumCurEarnings = 0;


class _ParkingsScreenState extends State<ParkingsScreen> {
  Future<List<ParkingLot>> parkinglots = getAllParkings();

  @override
  Widget build(BuildContext context) {


    return Column(
      children: [
        SizedBox(
            height: MediaQuery.of(context).size.height / 5,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height / 64),
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 128),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: const Color(0xff072338),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "suma\nzarobków",
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height / 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Jaldi',
                                  height: 1,
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "${sumEarningsToday.toStringAsFixed(2)} zł",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              8,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Jaldi',
                                      height: 1),
                                ),
                              )
                            ],
                          )),
                    ),
                  )),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 128),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: const Color(0xff072338),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "średnie zarobki\nna godzine",
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height / 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Jaldi',
                                  height: 1,
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "${sumCurEarnings.toStringAsFixed(2)} zł",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              8,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Jaldi',
                                      height: 1),
                                ),
                              )
                            ],
                          )),
                    ),
                  )),
                ],
              ),
            )),
        Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 128,
              width: MediaQuery.of(context).size.width * 51 / 52,
              child: Container(
                color: const Color(0xff072338),
              ),
            )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Text(
                "Moje parkingi: ",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height / 20,
                    color: const Color(0xFF0C3C61),
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Jaldi'),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/add_parking');
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xff156BAD), // Kolor tła przycisku
                    shape: BoxShape.circle, // Okrągły kształt
                  ), // Padding wewnątrz Containera
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 50, // Kolor ikony
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<ParkingLot>>(
            future: parkinglots,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (snapshot.hasData) {
                              sumEarningsToday = 0;
              sumCurEarnings = 0;
                return buildParkingLotList(snapshot.data!);
              } else {
                return Center(child: Text("No parkings found"));
              }
            },
          ),
        ),
      ],
    );
  }

  Widget buildParkingLotList(List<ParkingLot> parkingLots) {
    return Expanded(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: 10,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    buildParkingLotItem(parkingLots, index, 0),
                    buildParkingLotItem(parkingLots, index, 1),
                  ],
                ),
              );
            },
          )),
    );
  }

  Widget buildParkingLotItem(
      List<ParkingLot> parkingLots, int index, int rowIndex) {
    if (index * 2 + rowIndex >= parkingLots.length) {
      return Expanded(child: Container());
    }
    for (int i = 0; i < parkingLots.length; i++) {
      sumEarningsToday += parkingLots[i].earningsToday;
      sumCurEarnings += parkingLots[i].curEarnings;
    }

    return Expanded(
        child: GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/manageParking',
          arguments: parkingLots[index * 2 + rowIndex],
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
            decoration: BoxDecoration(
                color: const Color(0xff0C3C61),
                borderRadius: BorderRadius.circular(25)),
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          parkingLots[index * 2 + rowIndex].name,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height / 24,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Jaldi'),
                        ),
                        SizedBox(
                          child: Container(
                            color: Colors.white,
                            height: 5,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "adres:",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height / 26,
                                  color: Colors.white,
                                  height: 1.2,
                                  fontFamily: 'Jaldi'),
                            ),
                            Text(
                              parkingLots[index * 2 + rowIndex].address,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height / 26,
                                  height: 1.2,
                                  color: Colors.white,
                                  fontFamily: 'Jaldi'),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "zajęte miejsca:",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height / 26,
                                  height: 1.2,
                                  color: Colors.white,
                                  fontFamily: 'Jaldi'),
                            ),
                            Text(
                              "${parkingLots[index * 2 + rowIndex].currentOccupancy}/${parkingLots[index * 2 + rowIndex].capacity}",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height / 26,
                                  height: 1.2,
                                  color: Colors.white,
                                  fontFamily: 'Jaldi'),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "zarobki dzisiaj:",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height / 26,
                                  height: 1.2,
                                  color: Colors.white,
                                  fontFamily: 'Jaldi'),
                            ),
                            Text(
                              "${parkingLots[index * 2 + rowIndex].earningsToday.toStringAsFixed(2)} zł",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height / 26,
                                  height: 1.2,
                                  color: Colors.white,
                                  fontFamily: 'Jaldi'),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "zarobki chwilowe:",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height / 26,
                                  height: 1.2,
                                  color: Colors.white,
                                  fontFamily: 'Jaldi'),
                            ),
                            Text(
                              "${parkingLots[index * 2 + rowIndex].curEarnings.toStringAsFixed(2)} zł",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height / 26,
                                  height: 1.2,
                                  color: Colors.white,
                                  fontFamily: 'Jaldi'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                        right: 0,
                        top: 0,
                        child: Row(
                          children: [
                            Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  child: Text(
                                    "edytuj",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height <
                                              MediaQuery.of(context).size.width
                                          ? MediaQuery.of(context).size.height /
                                              25
                                          : MediaQuery.of(context).size.width /
                                              25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Jaldi',
                                      fontStyle: FontStyle.italic,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.white,
                                      decorationThickness: 3.0,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      Navigator.pushNamed(
                                        context,
                                        '/edit_parking',
                                        arguments:
                                            parkingLots[index * 2 + rowIndex],
                                      );
                                    });
                                  },
                                )),
                            Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  child: Text(
                                    "X",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.height /
                                                24,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'Jaldi'),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      parkingLots
                                          .removeAt(index * 2 + rowIndex);
                                      deleteparking(
                                          parkingLots[index * 2 + rowIndex].id);
                                    });
                                  },
                                ))
                          ],
                        ))
                  ],
                ))),
      ),
    ));
  }
}
