import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class AddParkingScreen extends StatefulWidget {
  const AddParkingScreen({super.key});

  @override
  _AddParkingScreenState createState() => _AddParkingScreenState();
}

class _AddParkingScreenState extends State<AddParkingScreen> {

  TextEditingController parkingNameController = TextEditingController();
  TextEditingController parkingAddressController = TextEditingController();
  TextEditingController parkingHoursController = TextEditingController();
  TextEditingController parkingDTariffController = TextEditingController();
  TextEditingController parkingNTariffController = TextEditingController();
  TextEditingController parkingFloorsController = TextEditingController();
  TextEditingController parkingSpotsController = TextEditingController();

   final apiUrl = "http://127.0.0.1:5000/add_parking";
  Future<void> sendPostRequest() async {
    await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": parkingNameController.text,
        "address": parkingAddressController.text,
        "capacity": double.parse(parkingFloorsController.text) * double.parse(parkingSpotsController.text),
        "dayTariff": double.parse(parkingDTariffController.text),
        "nightTariff": double.parse(parkingNTariffController.text),
        "operatingHours": parkingHoursController.text,
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      'Dodawanie parkingu',
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
                                                controller: parkingAddressController,
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
                                                controller: parkingHoursController,
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
                                                controller: parkingDTariffController,
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
                                                controller: parkingNTariffController,
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
                                              "[suma]",
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
