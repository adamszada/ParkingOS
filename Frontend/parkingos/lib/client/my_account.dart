import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:parkingos/util/my_ticket.dart';
import '../globals.dart' as globals;
import 'package:http/http.dart' as http;

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  _MyAccountState createState() => _MyAccountState();
}

Future<List<MyTicket>> getTickets() async {
  print(globals.userID);
  var url = Uri.parse("http://127.0.0.1:5000/tickets_data/" + globals.userID);
  final response =
      await http.get(url, headers: {"Content-Type": "application/json"});
  if (response.statusCode == 200) {
    final Map<String, dynamic>? data = json.decode(response.body);
    if (data != null && data.containsKey('tickets')) {
      final List<dynamic> carsList = data['tickets'];
      print(data['tickets']);
      return carsList.map((e) => MyTicket.fromJson(e)).toList();
    } else {
      // Handle missing or invalid JSON data
      throw Exception('Invalid JSON data');
    }
  } else {
    // Handle error or return an empty list
    throw Exception('Failed to load tickets');
  }
}

Future<List<MyTicket>> ticketsFuture = getTickets();

Future<double> getUserBalance() async {
  // Use string interpolation for cleaner URL construction.
  var url = Uri.parse("http://127.0.0.1:5000/get_user/" + globals.currentUser);
  final response =
      await http.get(url, headers: {"Content-Type": "application/json"});

  if (response.statusCode == 200) {
    final data = json.decode(response.body) as Map<String, dynamic>;
    // Check if 'saldo' exists and is a number, then convert to double as needed.
    if (data != null && data.containsKey('saldo')) {
      // Use 'num' to ensure compatibility with int and double, then convert to double.
      final double saldo = double.parse(data['saldo'].toString());
      return saldo;
    } else {
      throw Exception('Invalid JSON data: saldo key not found');
    }
  } else {
    throw Exception(
        'Failed to load balance with status code ${response.statusCode}');
  }
}

class _MyAccountState extends State<MyAccount> {
  String extractUsernameFromEmail(String email) {
    if (email.contains('@')) {
      List<String> parts = email.split('@');
      return parts.first;
    } else {
      return email;
    }
  }

  Future<double> balance = getUserBalance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Column(children: [
          SizedBox(height: 200),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 5 / 7,
              height: MediaQuery.of(context).size.height * 5 / 14,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: const Color(0xffF0F0F0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Row(
                      // mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                extractUsernameFromEmail(globals.currentUser),
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height / 20,
                                    color: const Color(0xFF0C3C61),
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Jaldi'),
                              ),
                              Text(
                                "e-mail:",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height / 30,
                                    color: const Color(0xFF0C3C61),
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Jaldi'),
                              ),
                              Text(
                                globals.currentUser,
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height / 30,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Jaldi'),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 30, top: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/changeemail');
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
                                        "zmień e-mail",
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                30,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontFamily: 'Jaldi'),
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 30, top: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/newpassword');
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
                                        "zmień hasło",
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                30,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontFamily: 'Jaldi'),
                                      ),
                                    ))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Saldo:",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height / 20,
                                    color: const Color(0xFF0C3C61),
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Jaldi'),
                              ),
                              FutureBuilder(
                                  future: balance,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text("Error: ${snapshot.error}"));
                                    } else if (snapshot.hasData) {
                                      return Text(
                                        "${snapshot.data} zł",
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w900,
                                            fontFamily: 'Jaldi'),
                                      );
                                    } else {
                                      return Center(
                                          child: Text("No parkings found"));
                                    }
                                  }),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/topup');
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
                                        "doładuj saldo",
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                30,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontFamily: 'Jaldi'),
                                      ),
                                    ))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        "Moje bilety:",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height / 20,
                            color: const Color(0xFF0C3C61),
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Jaldi'),
                      ),
                    ),
                  ],
                ),
                
                Row(
                  children: [
                    Expanded(
                      child: FutureBuilder<List<MyTicket>>(
                        future: ticketsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text("Error: ${snapshot.error}"));
                          } else if (snapshot.hasData) {
                            return buildMyTicketList(snapshot.data!);
                          } else {
                            return Center(child: Text("No tickets found"));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ]))
        ])));
  }

  Widget buildMyTicketList(List<MyTicket> tickets) {
    return Expanded(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
          child: ListView.builder(
            shrinkWrap: true, // Important for ListView in a Column
            physics:
                NeverScrollableScrollPhysics(), // Disables scrolling within ListView
            itemCount: (tickets.length / 3).ceil(), // Adjust item count
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Row(
                  children: [
                    buildMyTicketItem(tickets, index, 0),
                    buildMyTicketItem(tickets, index, 1),
                    buildMyTicketItem(tickets, index, 2),
                  ],
                ),
              );
            },
          )),
    );
  }

  Widget buildMyTicketItem(List<MyTicket> tickets, int index, int rowIndex) {
    if (index * 3 + rowIndex >= tickets.length) {
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
                        tickets[index * 3 + rowIndex].carName,
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
                            "rejestracja:",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height / 26,
                                color: Colors.white,
                                height: 1.2,
                                fontFamily: 'Jaldi'),
                          ),
                          Text(
                            tickets[index * 3 + rowIndex].registration,
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
                            "od:",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height / 26,
                                height: 1.2,
                                color: Colors.white,
                                fontFamily: 'Jaldi'),
                          ),
                          Text(
                            tickets[index * 3 + rowIndex].parkTime.toString(),
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
                            "adres:",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height / 26,
                                height: 1.2,
                                color: Colors.white,
                                fontFamily: 'Jaldi'),
                          ),
                          Text(
                            tickets[index * 3 + rowIndex].parkingAddress,
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
                            "miejsce:",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height / 26,
                                height: 1.2,
                                color: Colors.white,
                                fontFamily: 'Jaldi'),
                          ),
                          Text(
                            "P${tickets[index * 3 + rowIndex].floor}M${tickets[index * 3 + rowIndex].parkingSpotNumber}",
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
                            "koszt:",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height / 26,
                                height: 1.2,
                                color: Colors.white,
                                fontFamily: 'Jaldi'),
                          ),
                          Text(
                            "${tickets[index * 3 + rowIndex].moneyDue.toString()} zł",
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
                          "QR",
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
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                elevation: 16,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: const Color(0xffD9D9D9),
                                      borderRadius: BorderRadius.circular(25)),
                                  child: Text(
                                    tickets[index * 3 + rowIndex].qrCode,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.height /
                                                24,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'Jaldi'),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ))
                ],
              ))),
    ));
  }
}
