import 'package:flutter/material.dart';
import 'package:parkingos/util/parking_lot.dart';
import 'package:parkingos/util/parking_user.dart';

class ParkingUsersPage extends StatefulWidget {
  final ParkingLot parking;
  const ParkingUsersPage({super.key, required this.parking});

  @override
  ParkingUsersPageState createState() =>
      ParkingUsersPageState(parking: this.parking);
}

List<ParkingUser> userList = [
  ParkingUser(login: "Anna", balance: 50.0),
  ParkingUser(login: "Tomasz", balance: 75.0),
  ParkingUser(login: "Katarzyna", balance: 60.0),
  ParkingUser(login: "Marcin", balance: 45.0),
  ParkingUser(login: "Ewa", balance: 80.0),
];
final tab = [1, 0, 0, 0, 0];

class ParkingUsersPageState extends State<ParkingUsersPage> {
  final ParkingLot parking;
  ParkingUsersPageState({required this.parking});
  @override
  Widget build(BuildContext context) {
    TextEditingController searchbarController = TextEditingController();

    return SafeArea(
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15, bottom: 3),
                      child: Text(
                        "szukaj:",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.height / 48),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchbarController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.8),
                            hintText: 'Wyszukaj...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                searchbarController.clear();
                                setState(() {});
                              },
                            )),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return buildParkingLotItem(index);
                      },
                      itemCount: userList.length,
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

  Widget buildParkingLotItem(int index) {
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
                          "${userList[index].login}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.height / 40),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "${userList[index].balance} zł",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.height / 40),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(130, 255, 0, 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: const Text(
                            "zablokuj",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          tab[index] == 1 ? tab[index] = 0 : tab[index] = 1;
                          setState(() {});
                        },
                        icon: Icon(
                          tab[index] == 0
                              ? Icons.arrow_drop_down_circle
                              : Icons.keyboard_arrow_up_outlined,
                          size: MediaQuery.of(context).size.height / 32,
                          opticalSize: MediaQuery.of(context).size.height / 32,
                        ),
                        iconSize: MediaQuery.of(context).size.height / 64,
                        padding: EdgeInsets.zero,
                      )
                    ]),
                    tab[index] == 1
                        ? Row(
                            children: [
                              Expanded(
                                  child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Container(
                                          height: 2,
                                          color: Colors.black,
                                        ),
                                      )),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "RENAULT | CLIO | ETM CU48",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                40),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.search),
                                        color: Colors.blue,
                                      )
                                    ],
                                  )
                                ],
                              ))
                            ],
                          )
                        : Container()
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
