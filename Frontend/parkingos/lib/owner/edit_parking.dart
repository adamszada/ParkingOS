import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:parkingos/util/parking_lot.dart';
import 'package:http/http.dart' as http;

class EditParkingPage extends StatefulWidget {
  final ParkingLot parking;
  const EditParkingPage({super.key, required this.parking});


  @override
  EditParkingPageState createState() =>
      EditParkingPageState(parking: this.parking);
}

class EditParkingPageState extends State<EditParkingPage> {
  final ParkingLot parking;
  EditParkingPageState({required this.parking});
  int _totalSpots = 0;

  TextEditingController parkingNameController = TextEditingController();
  TextEditingController parkingAddressController = TextEditingController();
  TextEditingController parkingHoursController = TextEditingController();
  TextEditingController parkingDTariffController = TextEditingController();
  TextEditingController parkingNTariffController = TextEditingController();
  TextEditingController parkingFloorsController = TextEditingController();
  TextEditingController parkingSpotsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeTextControllers();
  }

  void _initializeTextControllers() {
    if (parkingNameController.text.isEmpty) {
      parkingNameController.text = parking.name;
    }
    if (parkingAddressController.text.isEmpty) {
      parkingAddressController.text = parking.address;
    }
    if (parkingHoursController.text.isEmpty) {
      parkingHoursController.text = parking.operatingHours;
    }
    if (parkingDTariffController.text.isEmpty) {
      parkingDTariffController.text = parking.dayTariff.toString();
    }
    if (parkingNTariffController.text.isEmpty) {
      parkingNTariffController.text = parking.nightTariff.toString();
    }
    if (parkingFloorsController.text.isEmpty) {
      parkingFloorsController.text = parking.floors.toString();
    }
    if (parkingSpotsController.text.isEmpty) {
      parkingSpotsController.text = parking.capacityPerFloor.toString();
    }
  }

  final apiUrl = "http://127.0.0.1:5000/update_parking/";
  Future<void> sendPostRequest() async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": parkingNameController.text,
        "address": parkingAddressController.text,
        "floors": int.parse(parkingFloorsController.text),
        "spots_per_floor": int.parse(parkingSpotsController.text),
        "dayTariff": double.parse(parkingDTariffController.text),
        "nightTariff": double.parse(parkingNTariffController.text),
        "operatingHours": parkingHoursController.text,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pushNamed(context, '/owner');
      print("Parking edited");
    } else {
      print("Parking not edited");
    }
  }

  @override
  Widget build(BuildContext context) {
    void _updateTotalSpots() {
      setState(() {
        _totalSpots = (parkingSpotsController.text != ""
                        ? int.parse(parkingSpotsController.text)
                        : 0) *
                    (parkingFloorsController.text != ""
                        ? int.parse(parkingFloorsController.text)
                        : 0) >
                0
            ? (int.parse(parkingFloorsController.text) *
                int.parse(parkingSpotsController.text))
            : 0;
      });
      // Tutaj można dodać logikę wyszukiwania, np. zaktualizować listę wyników.
    }

    return Scaffold(
        body: Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height / 32,
                horizontal: MediaQuery.of(context).size.width / 32),
            child: SizedBox.expand(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Edycja parkingu',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: const Color(0xff0C3C61),
                          fontWeight: FontWeight.w900,
                          fontSize: MediaQuery.of(context).size.height / 24),
                    ),
                    Container(
                        decoration: BoxDecoration(
                            color: const Color(0xffF0F0F0),
                            borderRadius: BorderRadius.circular(25)),
                        child: Padding(
                          padding: const EdgeInsets.all(25),
                          child: Column(children: [
                            Padding(
                                padding: const EdgeInsets.all(5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text(
                                        "nazwa parkingu:",
                                        style: TextStyle(
                                            color: Color(0xff0C3C61),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    TextField(
                                      controller: parkingNameController,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                            Padding(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 15),
                                                child: Text(
                                                  "adres:",
                                                  style: TextStyle(
                                                      color: Color(0xff0C3C61),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              TextField(
                                                controller:
                                                    parkingAddressController,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                ),
                                              )
                                            ],
                                          )),
                                    ),
                                    Expanded(
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 15),
                                                child: Text(
                                                  "godziny otwarcia:",
                                                  style: TextStyle(
                                                      color: Color(0xff0C3C61),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              TextField(
                                                controller:
                                                    parkingHoursController,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                ),
                                              )
                                            ],
                                          )),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 15),
                                                child: Text(
                                                  "taryfa dzienna:",
                                                  style: TextStyle(
                                                      color: Color(0xff0C3C61),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              TextField(
                                                controller:
                                                    parkingDTariffController,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                ),
                                              )
                                            ],
                                          )),
                                    ),
                                    Expanded(
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 15),
                                                child: Text(
                                                  "taryfa nocna:",
                                                  style: TextStyle(
                                                      color: Color(0xff0C3C61),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              TextField(
                                                controller:
                                                    parkingNTariffController,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                ),
                                              )
                                            ],
                                          )),
                                    ),
                                  ],
                                )),
                            const Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 15),
                                              child: Text(
                                                "liczba pięter:",
                                                style: TextStyle(
                                                    color: Color(0xff0C3C61),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                  Expanded(
                                    child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 15),
                                              child: Text(
                                                "liczba miejsc na piętro:",
                                                style: TextStyle(
                                                    color: Color(0xff0C3C61),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                  Expanded(
                                    child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 15),
                                              child: Text(
                                                "wszystkie miejsca:",
                                                style: TextStyle(
                                                    color: Color(0xff0C3C61),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Container(
                                height: MediaQuery.of(context).size.height / 16,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: TextField(
                                            controller: parkingFloorsController,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),
                                            onChanged: (value) {
                                              _updateTotalSpots();
                                            },
                                          )),
                                    ),
                                    Expanded(
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: TextField(
                                            controller: parkingSpotsController,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),
                                            onChanged: (value) {
                                              _updateTotalSpots();
                                            },
                                          )),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xff156BAD),
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          child: Expanded(
                                              child: Center(
                                            child: Text(
                                              _totalSpots > 0
                                                  ? _totalSpots.toString()
                                                  : (parking.capacityPerFloor *
                                                          parking.floors)
                                                      .toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          32),
                                            ),
                                          )),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height / 16,
                                child: Row(
                                  children: [
                                    const Expanded(child: SizedBox()),
                                    Expanded(
                                        child: TextButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFF0C3C61),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              ),
                                            ),
                                            onPressed: () {
                                              sendPostRequest();
                                            },
                                            child: Center(
                                              child: Text(
                                                "zapisz",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            32),
                                              ),
                                            ))),
                                    const Expanded(child: SizedBox()),
                                  ],
                                ),
                              ),
                            )
                          ]),
                        ))
                  ],
                ),
              ),
            )));
  }
}
