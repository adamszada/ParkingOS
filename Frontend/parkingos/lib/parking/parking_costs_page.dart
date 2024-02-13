// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:parkingos/util/parking_cost.dart';
import 'package:parkingos/util/parking_lot.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ParkingCostsPage extends StatefulWidget {
  final ParkingLot parking;
  const ParkingCostsPage({super.key, required this.parking});

  @override
  ParkingCostsPageState createState() =>
      ParkingCostsPageState(parking: this.parking);
}

class ParkingCostsPageState extends State<ParkingCostsPage> {
  final ParkingLot parking;
  ParkingCostsPageState({required this.parking});
  TextEditingController tittleController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  List<ParkingCost> costList = [];

  Future<void> fetchParkingCosts() async {
    final apiUrl = "http://127.0.0.1:5000/parking_costs/${parking.id}";
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        print(data);
        costList = (data['parking_costs'] as List)
            .map((json) => ParkingCost.fromJson(json))
            .toList();
      });
    } else {
      throw Exception('Failed to load parking costs');
    }
  }

  Future<void> deleteParkingCost(int costId) async {
    final apiUrl = "http://127.0.0.1:5000/parking_costs/delete/${parking.id}";
    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "amount": costList[costId].amount,
        "title": costList[costId].tittle,
        "type": costList[costId].type,
      }),
    );

    if (response.statusCode == 200) {
      fetchParkingCosts();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchParkingCosts();
  }

  Future<void> addParkingCost() async {
    final apiUrl = "http://127.0.0.1:5000/parking_costs/add";
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "parking_id": parking.id,
        "amount": double.parse(amountController.text),
        "title": tittleController.text,
        "type": type,
      }),
    );

    if (response.statusCode == 200) {
      costList.add(ParkingCost(
        amount: double.parse(amountController.text),
        tittle: tittleController.text,
        type: type,
      ));
      tittleController.clear();
      amountController.clear();
      setState(() {});
    } else {
      final responseBody = jsonDecode(response.body);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(responseBody["message"]),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  List<String> types = ["jednorazowy", "cykliczny"];
  String type = "jednorazowy";

  @override
  Widget build(BuildContext context) {
    double sumCosts = 0;
    for (int i = 0; i < costList.length; i++) {
      sumCosts += costList[i].amount;
    }

    return SafeArea(
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: SizedBox(
            child: Column(
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "suma kosztów:",
                                style: TextStyle(
                                    color: const Color(0xff0C3C61),
                                    fontFamily: "Jaldi",
                                    fontWeight: FontWeight.w700,
                                    fontSize:
                                        MediaQuery.of(context).size.height /
                                            12),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${sumCosts.toStringAsFixed(2)} zł",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: const Color(0xff0C3C61),
                                    fontFamily: "Jaldi",
                                    fontWeight: FontWeight.w700,
                                    fontSize:
                                        MediaQuery.of(context).size.height /
                                            12),
                              ),
                            )
                          ]),
                    )),
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        height: 4,
                        color: Colors.white,
                      ),
                    )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Text(
                          "nazwa:",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Jaldi",
                              fontWeight: FontWeight.w700,
                              fontSize:
                                  MediaQuery.of(context).size.height / 48),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Text(
                          "typ:",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Jaldi",
                              fontWeight: FontWeight.w700,
                              fontSize:
                                  MediaQuery.of(context).size.height / 48),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Text(
                          "kwota:",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Jaldi",
                              fontWeight: FontWeight.w700,
                              fontSize:
                                  MediaQuery.of(context).size.height / 48),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 24,
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0xff156BAD),
                          borderRadius: BorderRadius.circular(25)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                child: TextField(
                                  controller: tittleController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding:
                                        const EdgeInsets.only(left: 15),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      // borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                    child: DropdownButton<String>(
                                      value: type,
                                      borderRadius: BorderRadius.circular(25),
                                      underline: Container(),
                                      isExpanded: true,
                                      menuMaxHeight:
                                          (MediaQuery.of(context).size.height ~/
                                                  3)
                                              .toDouble(),
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.height <
                                                    MediaQuery.of(context)
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
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          type = newValue!;
                                        });
                                      },
                                      items: types
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
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                child: TextField(
                                  controller: amountController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding:
                                        const EdgeInsets.only(left: 15),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      // borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "zł",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Jaldi",
                                  fontWeight: FontWeight.w700,
                                  fontSize:
                                      MediaQuery.of(context).size.height / 32),
                            ),
                            IconButton(
                              onPressed: () {
                                if (tittleController.text.isNotEmpty &&
                                    amountController.text.isNotEmpty &&
                                    type.isNotEmpty) {
                                  addParkingCost();
                                  setState(() {});
                                }
                              },
                              padding: EdgeInsets.zero,
                              icon: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Center(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              40,
                                      width:
                                          MediaQuery.of(context).size.height /
                                              40,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Icon(
                                    Icons.add_circle_outlined,
                                    color: const Color(0xff0C3C61),
                                    size:
                                        MediaQuery.of(context).size.height / 20,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return buildParkingCostItem(index);
                      },
                      itemCount: costList.length,
                      scrollDirection: Axis.vertical,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
                child: Column(
                  children: [
                    Row(children: [
                      Expanded(
                        child: Text(
                          costList[index].tittle,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height / 40),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "${costList[index].type}",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height / 40),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "${costList[index].amount.toStringAsFixed(2)} zł",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height / 40),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            deleteParkingCost(index);
                            // costList.removeAt(index);
                            setState(() {});
                          },
                          padding: EdgeInsets.zero,
                          icon: Container(
                            decoration: BoxDecoration(
                                color: Colors.red[200],
                                borderRadius: BorderRadius.circular(100)),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          )),
                    ]),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
