import 'package:flutter/material.dart';
import 'package:parkingos/parking/parking_costs_page.dart';
import 'package:parkingos/parking/parking_users_page.dart';
import 'package:parkingos/parking/this_parking_page.dart';
import 'package:parkingos/util/parking_lot.dart';

class ManageParkingScreen extends StatefulWidget {
  final ParkingLot parking;
  const ManageParkingScreen({super.key, required this.parking});

  @override
  ManageParkingScreenState createState() =>
      ManageParkingScreenState(parking: this.parking);
}

class ManageParkingScreenState extends State<ManageParkingScreen> {
  int selectedIndex = 0;
  final ParkingLot parking;
  ManageParkingScreenState({required this.parking});
  @override
  Widget build(BuildContext context) {
    final tabs = [
      ThisParkingPage(parking: parking),
      ParkingUsersPage(parking: parking),
      Container(color: Colors.green),
      ParkingCostsPage(parking: parking),
      Container(color: Colors.orange),
      Container(color: Colors.red),
    ];
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height / 8),
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width / 128,
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'wyloguj',
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 128,
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 10,
                      child: Image.asset(
                        'assets/parking.png',
                        alignment: Alignment.topCenter,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  )),
              Align(
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 24,
                    width: MediaQuery.of(context).size.width / 3,
                    child: Row(
                      children: [
                        Expanded(
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/owner');
                                },
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height / 24,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      topRight: Radius.circular(25),
                                    ),
                                  ),
                                  child: Text(
                                    "moje parkingi",
                                    textAlign: TextAlign.center,
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
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'Jaldi'),
                                  ),
                                )))
                      ],
                    ),
                  )),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 128,
                    child: Container(
                      color: const Color(0xff072338),
                    ),
                  )),
            ],
          )),
      body: SafeArea(
        child: Center(
          child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 32,
                vertical: MediaQuery.of(context).size.height / 32,
              ),
              child: Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 8,
                    child: Row(
                      children: [
                        buildNavigationItem("ten parking", 0),
                        buildNavigationItem("użytkownicy", 1),
                        buildNavigationItem("live view", 2),
                        buildNavigationItem("koszty", 3),
                        buildNavigationItem("statystyki", 4),
                        buildNavigationItem("podsumowanie", 5),
                        Expanded(child: Container())
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 16,
                      ),
                      Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xff0C3C61),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: tabs[selectedIndex],
                            )),
                      )
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget buildNavigationItem(String name, int index) {
    return Expanded(
        child: GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Container(
                height: MediaQuery.of(context).size.height / 8,
                decoration: BoxDecoration(
                  color: index == selectedIndex
                      ? const Color(0xff0C3C61)
                      : Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height <
                                MediaQuery.of(context).size.width
                            ? MediaQuery.of(context).size.height / 30
                            : MediaQuery.of(context).size.width / 30,
                        color: index == selectedIndex
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Jaldi'),
                  ),
                ))));
  }
}
