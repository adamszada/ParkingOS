import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:parkingos/util/vehicle.dart';
import 'package:http/http.dart' as http;
import '../globals.dart' as globals;


class AddVehiclePage extends StatefulWidget {
  const AddVehiclePage({super.key});

  @override
  _AddVehiclePageState createState() => _AddVehiclePageState();
}

Future<void> deleteCar(String registration) async {
  var url = Uri.parse('http://127.0.0.1:5000/delete_car/$registration');

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

Future<List<Vehicle>> getVehicles(String ownerId) async {
  var url = Uri.parse("http://127.0.0.1:5000/get_cars_by_owner/" + ownerId);
  final response =
      await http.get(url, headers: {"Content-Type": "application/json"});
  if (response.statusCode == 200) {
    final Map<String, dynamic>? data = json.decode(response.body);
    if (data != null && data.containsKey('cars')) {
      final List<dynamic> carsList = data['cars'];
      return carsList.map((e) => Vehicle.fromJson(e)).toList();
    } else {
      throw Exception('Invalid JSON data');
    }
  } else {
    throw Exception('Failed to load vehicles');
  }
}

// List<Vehicle> vehicles = [
//   Vehicle(registration: 'ABC 123', model: 'Model 3', brand: 'Tesla'),
//   Vehicle(registration: 'DEF 456', model: 'Mustang', brand: 'Ford'),
//   Vehicle(registration: 'GHI 789', model: 'Civic', brand: 'Honda'),
//   Vehicle(registration: 'JKL 012', model: 'Corolla', brand: 'Toyota'),
//   Vehicle(registration: 'MNO 345', model: 'CX-5', brand: 'Mazda'),
//   Vehicle(registration: 'PQR 678', model: '911', brand: 'Porsche'),
//   Vehicle(registration: 'STU 901', model: 'X7', brand: 'BMW'),
//   Vehicle(registration: 'VWX 234', model: 'A8', brand: 'Audi'),
//   Vehicle(registration: 'YZA 567', model: 'Camry', brand: 'Toyota'),
//   Vehicle(registration: 'BCD 890', model: 'Cherokee', brand: 'Jeep')
// ];

class _AddVehiclePageState extends State<AddVehiclePage> {
  TextEditingController brandController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController registrationController = TextEditingController();

  final apiUrl = "http://127.0.0.1:5000/add_car";
  Future<void> sendPostRequest() async {
    await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "brand": brandController.text.toUpperCase(),
        "model": modelController.text.toUpperCase(),
        "registration": registrationController.text.toUpperCase(),
        "owner_id": globals.userID,
      }),
    );
  }

  Future<List<Vehicle>> vehiclesFuture = getVehicles(globals.userID);



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
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    "Dodawanie pojazdu",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 20,
                        color: const Color(0xFF0C3C61),
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Jaldi'),
                  ),
                ),
                Container(
                    decoration: BoxDecoration(
                        color: const Color(0xffF0F0F0),
                        borderRadius: BorderRadius.circular(50)),
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
                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'rejestracja',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color(0xff0C3C61),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                TextField(
                                  controller: registrationController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'marka',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color(0xff0C3C61),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                TextField(
                                  controller: brandController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'model',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color(0xff0C3C61),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                TextField(
                                  controller: modelController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                )
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
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if (registrationController.text != "" &&
                                      modelController.text != "" &&
                                      brandController.text != "") {
                                    sendPostRequest();

                                    registrationController.text = "";
                                    modelController.text = "";
                                    brandController.text = "";
                                  }
                                });
                                setState(() {
                                  
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0C3C61),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  "dodaj pojazd",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              40,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Jaldi'),
                                ),
                              )))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    "Moje pojazdy:",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 20,
                        color: const Color(0xFF0C3C61),
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Jaldi'),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<Vehicle>>(
                    future: vehiclesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (snapshot.hasData) {
                        return buildVehicleList(snapshot.data!);
                      } else {
                        return Center(child: Text("No vehicles found"));
                      }
                    },
                  ),
                ),
              ],
            )));
  }

  Widget buildVehicleList(List<Vehicle> vehicles) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: vehicles.length % 3 != 0
            ? vehicles.length ~/ 3 + 1
            : vehicles.length ~/ 3,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                buildCarItem(vehicles, index, 0),
                buildCarItem(vehicles, index, 1),
                buildCarItem(vehicles, index, 2)
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildCarItem(List<Vehicle> vehicles, int index, int rowIndex) {
    if (index * 3 + rowIndex >= vehicles.length) {
      return Expanded(child: Container());
    }

    final Vehicle vehicle = vehicles[index * 3 + rowIndex];
    final String registration = vehicle.registration ?? ''; // Use empty string if registration is null
    final String brand = vehicle.brand ?? ''; // Use empty string if brand is null
    final String model = vehicle.model ?? ''; // Use empty string if model is null

    return Expanded(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
          decoration: BoxDecoration(
              color: const Color(0xff156BAD),
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
                        registration,
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
                      Text(
                        brand,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height / 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Jaldi'),
                      ),
                      Text(
                        model,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height / 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Jaldi'),
                      ),
                    ],
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        child: Text(
                          "X",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height / 24,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Jaldi'),
                        ),
                        onPressed: () {
                          setState(() {
                            vehicles.removeAt(index * 3 + rowIndex);
                            deleteCar(vehicle.registration);
                          });
                        },
                      ))
                ],
              ))),
    ));
  }
}
