import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parkingos/util/parking_cost.dart';
import 'package:intl/intl.dart'; // Import intl package
import 'package:parkingos/util/parking_lot.dart';
import '../globals.dart' as globals;
import 'package:parkingos/util/vehicle.dart';
import 'package:parkingos/util/my_ticket.dart';

class BuyTicket extends StatefulWidget {
  final ParkingLot parking;
  const BuyTicket({super.key, required this.parking});

  @override
  _BuyTicketState createState() => _BuyTicketState(parking: this.parking);
}

Future<List<Vehicle>> getVehicles() async {
  var url =
      Uri.parse("http://127.0.0.1:5000/get_cars_by_owner/" + globals.userID);
  final response =
      await http.get(url, headers: {"Content-Type": "application/json"});
  if (response.statusCode == 200) {
    final Map<String, dynamic>? data = json.decode(response.body);
    if (data != null && data.containsKey('cars')) {
      final List<dynamic> carsList = data['cars'];
      return carsList.map((e) => Vehicle.fromJson(e)).toList();
    } else {
      // Handle missing or invalid JSON data
      throw Exception('Invalid JSON data');
    }
  } else {
    // Handle error or return an empty list
    throw Exception('Failed to load vehicles');
  }
}

Future<List<Vehicle>> vehiclesFuture = getVehicles();
List<Vehicle> usersVehicles = [];

class _BuyTicketState extends State<BuyTicket> {

  int selectedIndex = 0;
  final ParkingLot parking;
  String? firstvalue; // Declare firstvalue at the class level
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  _BuyTicketState({required this.parking});

  @override
  void initState() {
    super.initState();
    vehiclesFuture.then((vehicles) {
      if (vehicles.isNotEmpty) {
        setState(() {
          firstvalue = vehicles.first.registration; // Initialize firstvalue
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    String formattedTime = DateFormat('HH:mm').format(DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    ));

  final apiUrl = "http://127.0.0.1:5000/add_ticket";
  Future<void> sendPostRequest() async {
    await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_ID": globals.userID.toString(),
        "registration": firstvalue,
        "parking_id": parking.id,
        "exit_date": formattedDate,
        "exit_time": formattedTime,
        "entry_date": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "entry_time": DateFormat('HH:mm').format(DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      DateTime.now().hour,
      DateTime.now().minute,
    )),
      }),
    );
  }

    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                  width: MediaQuery.of(context).size.width / 6,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 50,
                        top: MediaQuery.of(context).size.width / 50),
                    child: Image.asset(
                      'assets/parking.png',
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.fitWidth,
                    ),
                  )),
            ),
            Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width * 5 / 17,
                    child: Text(
                      "Kup bilet",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 20,
                          color: const Color(0xFF0C3C61),
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Jaldi'),
                    )),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(50)),
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Wybierz auto:',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: const Color(0xFF0C3C61),
                                            fontFamily: "Jaldi",
                                            fontWeight: FontWeight.w900,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                45)),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: FutureBuilder<List<Vehicle>>(
                                            future: vehiclesFuture,
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              } else if (snapshot.hasError) {
                                                return Center(
                                                    child: Text(
                                                        "Error: ${snapshot.error}"));
                                              } else if (snapshot.hasData) {
                                                return DropdownButton<String>(
                                                  value: firstvalue,
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  underline: Container(),
                                                  isExpanded: true,
                                                  menuMaxHeight:
                                                      (MediaQuery.of(context)
                                                                  .size
                                                                  .height ~/
                                                              3)
                                                          .toDouble(),
                                                  style: TextStyle(
                                                    fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height <
                                                            MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width
                                                        ? MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            40
                                                        : MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            40,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w100,
                                                    fontFamily: 'Jaldi',
                                                    decorationThickness: 3.0,
                                                  ),
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      firstvalue = newValue;
                                                    });
                                                  },
                                                  items: snapshot.data!.map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (Vehicle vehicle) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value:
                                                          vehicle.registration,
                                                      child: Text(
                                                          vehicle.registration),
                                                    );
                                                  }).toList(),
                                                ); // Your method to build the list
                                              } else {
                                                return Center(
                                                    child: Text(
                                                        "No tickets found"));
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Do kiedy zostajesz:',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: const Color(0xFF0C3C61),
                                            fontFamily: "Jaldi",
                                            fontWeight: FontWeight.w900,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                45)),
                                  ),
                                ),
                                TextFormField(
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    hintText:
                                        "$formattedDate $formattedTime", // Display formatted date and time
                                    icon: Icon(Icons.calendar_today),
                                  ),
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: selectedDate,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2025),
                                    );
                                    if (pickedDate != null) {
                                      TimeOfDay? pickedTime =
                                          await showTimePicker(
                                        context: context,
                                        initialTime: selectedTime,
                                      );
                                      if (pickedTime != null) {
                                        setState(() {
                                          selectedDate = pickedDate;
                                          selectedTime = pickedTime;
                                        });
                                      }
                                    }
                                  },
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.height / 20,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() async {
                                          await sendPostRequest();
                                          Navigator.pop(context);
                                          //close this browser window after posting
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF0C3C61),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                      ),
                                      child: Text(
                                        'Kup',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Jaldi",
                                            fontWeight: FontWeight.w900,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                45),
                                      ),
                                    )),
                                const SizedBox(height: 16),
                              ]))),
                )
              ],
            ))
          ],
        ));
  }
}
