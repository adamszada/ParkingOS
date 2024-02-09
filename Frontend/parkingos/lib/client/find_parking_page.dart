import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:parkingos/util/parking_lot.dart';
import 'package:parkingos/util/vehicle.dart';
import 'package:http/http.dart' as http;

class FindParkingPage extends StatefulWidget {
  const FindParkingPage({super.key});

  @override
  _ParkingLotsPageState createState() => _ParkingLotsPageState();
}

Future<List<Vehicle>> getVehicles() async {
  var url = Uri.parse("http://127.0.0.1:5000/get_cars");
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

Future<List<ParkingLot>> getCheapestParkings() async {
  var url = Uri.parse("http://127.0.0.1:5000/get_cheapest_parking_lots");
  final response =
      await http.get(url, headers: {"Content-Type": "application/json"});
  if (response.statusCode == 200) {
    final Map<String, dynamic>? data = json.decode(response.body);
    if (data != null && data.containsKey('parkingLots')) {
      final List<dynamic> parkingList = data['parkingLots'];
      print(parkingList);
      return parkingList.map((e) => ParkingLot.fromJson(e)).toList();
    } else {
      // Handle missing or invalid JSON data
      throw Exception('Invalid JSON data');
    }
  } else {
    print(response.toString());
    // Handle error or return an empty list
    throw Exception('Failed to load parking lots');
  }
}

Future<List<ParkingLot>> getClosestParkings() async {
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
Future<List<Vehicle>> vehiclesFuture = getVehicles();
const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class _ParkingLotsPageState extends State<FindParkingPage> {
  int _selectedIndex = 0;

  Future<List<ParkingLot>> parkinglotsCheapest = getCheapestParkings();
  Future<List<ParkingLot>> parkinglotsClosest = getClosestParkings();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 64,
                vertical: MediaQuery.of(context).size.width / 64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 24,
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: Row(
                                      children: [
                                        buildNavigationItem(
                                            "Znajdź najbliższy", 0),
                                        buildNavigationItem(
                                            "Znajdź najtańszy", 1),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 25),
                                  decoration: const BoxDecoration(
                                    color: Color(0xff072338),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(50),
                                      bottomRight: Radius.circular(50),
                                      topRight: Radius.circular(50),
                                    ),
                                  ),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Adres',
                                      filled: true,
                                      fillColor: Colors
                                          .white, // This is the TextField's color
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 10.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ],
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0C3C61),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                "Szukaj",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height / 40,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Jaldi'),
                              ),
                            )),
                      ))
                    ],
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<ParkingLot>>(
                    future: _selectedIndex == 0
                        ? parkinglotsClosest
                        : parkinglotsCheapest,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (snapshot.hasData) {
                        return buildParkingLotList(snapshot.data!);
                      } else {
                        return Center(child: Text("No parkings found"));
                      }
                    },
                  ),
                ),
              ],
            )));
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
                    buildParkingLotItem(parkingLots, index, 2)
                  ],
                ),
              );
            },
          )),
    );
  }

  Widget buildNavigationItem(String name, int index) {
    return Expanded(
        child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            child: Container(
              height: MediaQuery.of(context).size.height / 24,
              decoration: BoxDecoration(
                color: index == _selectedIndex
                    ? const Color(0xFF072338)
                    : Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height <
                            MediaQuery.of(context).size.width
                        ? MediaQuery.of(context).size.height / 40
                        : MediaQuery.of(context).size.width / 40,
                    color:
                        index == _selectedIndex ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Jaldi'),
              ),
            )));
  }

  Widget buildParkingLotItem(
      List<ParkingLot> parkingLots, int index, int rowIndex) {
    if (index * 3 + rowIndex >= parkingLots.length) {
      return Expanded(child: Container());
    }
    return Expanded(
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
                        parkingLots[index * 3 + rowIndex].name,
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
                            parkingLots[index * 3 + rowIndex].address,
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
                            "${parkingLots[index * 3 + rowIndex].currentOccupancy}/${parkingLots[index * 2 + rowIndex].capacity}",
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
                            "taryfa dzienna:",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height / 26,
                                height: 1.2,
                                color: Colors.white,
                                fontFamily: 'Jaldi'),
                          ),
                          Text(
                            "${parkingLots[index * 3 + rowIndex].dayTariff} zł",
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
                            "taryfa nocna:",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height / 26,
                                height: 1.2,
                                color: Colors.white,
                                fontFamily: 'Jaldi'),
                          ),
                          Text(
                            "${parkingLots[index * 3 + rowIndex].nightTariff} zł",
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
                            "godziny otwarcia:",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height / 26,
                                height: 1.2,
                                color: Colors.white,
                                fontFamily: 'Jaldi'),
                          ),
                          Text(
                            parkingLots[index * 3 + rowIndex].operatingHours,
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
                  Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        child: Text(
                          "Parkuj",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height / 24,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Jaldi'),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                            return StatefulBuilder(
            builder: (context, setStateSB) =>   Dialog(
                                child: Container(
                                  padding: EdgeInsets.all(
                                      16), // Adjust padding as needed
                                  constraints: BoxConstraints(
                                      maxHeight:
                                          400), // Set a max height if needed
                                  child: FutureBuilder<List<Vehicle>>(
                                    future: vehiclesFuture,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                "Error: ${snapshot.error}"));
                                      } else if (snapshot.hasData) {
                                        return buildDialogItem(
                                            context,
                                            snapshot
                                                .data!); // Your method to build the list
                                      } else {
                                        return Center(
                                            child: Text("No tickets found"));
                                      }
                                    },
                                  ),
                                ),
                              ));
                            },
                          );
                        },
                      ))
                ],
              ))),
    ));
  }

Widget buildDialogItem(BuildContext context, List<Vehicle> vehicles) {
  // Using StatefulBuilder to manage local state within the dialog
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter setState) {
      // Initial values for state variables
      String dropdownValue = vehicles.first.registration;
      DateTime selectedDate = DateTime.now();
      TimeOfDay selectedTime = TimeOfDay.now();

      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        elevation: 16,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: const Color(0xffD9D9D9), borderRadius: BorderRadius.circular(25)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Color(0xff0C3C61)),
                  underline: Container(
                    height: 2,
                    color: Color(0xff0C3C61),
                  ),
                  onChanged: (String? value) {
                    // Update dropdownValue when a new item is selected
                    setState(() => dropdownValue = value!);
                  },
                  items: vehicles.map<DropdownMenuItem<String>>((Vehicle vehicle) {
                    return DropdownMenuItem<String>(
                      value: vehicle.registration,
                      child: Text(vehicle.registration),
                    );
                  }).toList(),
                ),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Do kiedy zostajesz?",
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
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (pickedTime != null) {
                        // Update selectedDate and selectedTime when new values are picked
                        setState(() {
                          selectedDate = pickedDate;
                          selectedTime = pickedTime;
                        });
                      }
                    }
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
}
