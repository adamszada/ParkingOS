import 'package:flutter/material.dart';
import 'package:parkingos/util/parking_lot.dart';
import 'package:parkingos/util/parking_user.dart';
import 'package:parkingos/util/vehicle.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ParkingUsersPage extends StatefulWidget {
  final ParkingLot parking;
  const ParkingUsersPage({super.key, required this.parking});

  @override
  ParkingUsersPageState createState() =>
      ParkingUsersPageState(parking: this.parking);
}

// List<ParkingUser> temp = [
//   ParkingUser(login: "Anna", balance: 50.0, isBlocked: true),
//   ParkingUser(login: "Tomasz", balance: 75.0),
//   ParkingUser(login: "Katarzyna", balance: 60.0),
//   ParkingUser(login: "Marcin", balance: 45.0),
//   ParkingUser(login: "Ewa", balance: 80.0),
// ];

int moreInfoIndex = -1;

class ParkingUsersPageState extends State<ParkingUsersPage> {
  final ParkingLot parking;

  ParkingUsersPageState({required this.parking});
  void _updateSearchTerm() {
    setState(() {
      _searchTerm = searchbarController.text;
    });
    // Tutaj można dodać logikę wyszukiwania, np. zaktualizować listę wyników.
  }

  List<ParkingUser> temp = [];
  Future<void> fetchParkingCosts() async {
    final apiUrl = "http://127.0.0.1:5000/users";
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        print(data);
        temp = (data['users'] as List)
            .map((json) => ParkingUser.fromJson(json))
            .toList();
      });
    } else {
      throw Exception('Failed to load parking costs');
    }
  }

  List<Vehicle> tempVehicle = [];
  Future<int> fetchCars(String userId, String parkingId) async {
    final Uri apiUrl = Uri.parse("http://127.0.0.1:5000/parking_history")
        .replace(queryParameters: {
      'user_id': userId,
      'parking_id': parkingId,
    });
    final response;
    if (tempVehicle.isEmpty) {
      response = await http.get(apiUrl);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          tempVehicle = (data['cars_history'] as List)
              .map((json) => Vehicle.fromJson(json))
              .toList();
        });
        return 0;
      } else {
        tempVehicle = [];
        throw Exception('Failed to load parking costs');
      }
    }
    return 1;
  }

  Future<void> banPword(String user_id, String parking_id, bool ban) async {
    final response = await http.post(
      Uri.parse("http://127.0.0.1:5000/ban_user"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
          {"user_id": user_id, "parking_id": parking_id, "ban": ban}),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchParkingCosts();
  }

  TextEditingController searchbarController = TextEditingController();
  String _searchTerm = "";
  String info = '';

  List<ParkingUser> selectItems(List<ParkingUser> list) {
    List<ParkingUser> new_list = [];
    if (_searchTerm == "") return list;

    for (int i = 0; i < list.length; i++) {
      if (list[i].login.toUpperCase().contains(_searchTerm.toUpperCase())) {
        new_list.add(list[i]);
      }
    }

    return new_list;
  }

  List<ParkingUser> userList = [];

  @override
  Widget build(BuildContext context) {
    userList = selectItems(temp);
    info = userList.isEmpty ? "Nie znaleziono pasującego użytkownika" : "";

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
                          hintText: "nazwa użytkownika",
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            icon: _searchTerm != ""
                                ? const Icon(Icons.clear)
                                : const Icon(Icons.search),
                            onPressed: () {
                              searchbarController.clear();
                              moreInfoIndex = -1;
                              _updateSearchTerm();
                            },
                          ),
                        ),
                        onChanged: (value) {
                          moreInfoIndex = -1;
                          _updateSearchTerm();
                        },
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            info,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height <
                                      MediaQuery.of(context).size.width
                                  ? MediaQuery.of(context).size.height / 20
                                  : MediaQuery.of(context).size.width / 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Jaldi',
                              decorationThickness: 3.0,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              info.isNotEmpty
                                  ? Container()
                                  : Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 25.0),
                                            child: Text(
                                              "użytkownik:",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "Jaldi",
                                                  fontWeight: FontWeight.w700,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          48),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 25.0),
                                            child: Text(
                                              "saldo:",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "Jaldi",
                                                  fontWeight: FontWeight.w700,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          48),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 25.0),
                                            child: Text(
                                              "",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "Jaldi",
                                                  fontWeight: FontWeight.w700,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          48),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              24,
                                        )
                                      ],
                                    ),
                              Expanded(
                                child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    return buildParkingUserItem(index);
                                  },
                                  itemCount: userList.length,
                                  scrollDirection: Axis.vertical,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Widget buildUserCarItem(int index) {
    return Row(
      children: [
        Text(
          "${tempVehicle[index].brand} | ${tempVehicle[index].model} | ${tempVehicle[index].registration}",
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: MediaQuery.of(context).size.height / 40),
        ),
      ],
    );
  }

  Widget buildParkingUserItem(int index) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Container(
              decoration: BoxDecoration(
                  color: userList[index].isBlocked == true
                      ? Colors.blueGrey
                      : Colors.white,
                  borderRadius: BorderRadius.circular(25)),
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
                          onPressed: () {
                            userList[index].isBlocked =
                                userList[index].isBlocked == true
                                    ? false
                                    : true;
                            setState(() {});
                            banPword(userList[index].id, parking.id,
                                userList[index].isBlocked);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: userList[index].isBlocked == true
                                ? Colors.green
                                : const Color.fromARGB(130, 255, 0, 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: Text(
                            userList[index].isBlocked == true
                                ? "odblokuj"
                                : "zablokuj",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (index != moreInfoIndex) {
                            moreInfoIndex = index;
                            fetchCars(userList[index].id, parking.id);
                          } else {
                            moreInfoIndex = -1;
                            tempVehicle = [];
                          }

                          setState(() {});
                        },
                        icon: Icon(
                          moreInfoIndex == index
                              ? Icons.arrow_drop_down_circle
                              : Icons.keyboard_arrow_up_outlined,
                          size: MediaQuery.of(context).size.height / 32,
                          opticalSize: MediaQuery.of(context).size.height / 32,
                        ),
                        iconSize: MediaQuery.of(context).size.height / 64,
                        padding: EdgeInsets.zero,
                      )
                    ]),
                    moreInfoIndex == index
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
                                  FutureBuilder(
                                      future: fetchCars(
                                          userList[index].id, parking.id),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Container();
                                        } else {
                                          return ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: tempVehicle
                                                .length, // Ilość elementów w wewnętrznej liście
                                            itemBuilder: (context, subIndex) {
                                              return buildUserCarItem(subIndex);
                                            },
                                          );
                                        }
                                      }),
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
