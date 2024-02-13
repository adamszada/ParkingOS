import 'package:flutter/material.dart';
import 'package:parkingos/main.dart';
import 'package:parkingos/owner/parkings_screen.dart';
import '../globals.dart' as globals;

class OwnerScreen extends StatefulWidget {
  const OwnerScreen({super.key});

  @override
  OwnerScreenState createState() => OwnerScreenState();
}

class OwnerScreenState extends State<OwnerScreen> {
  int selectedIndex = 0;
  final tabs = [const ParkingsScreen()];

  OwnerScreenState();
  @override
  Widget build(BuildContext context) {
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
                        onPressed: () {
                          globals.currentUser = "";
                          globals.userID = "";
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyHomePage()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: const Text(
                          'wyloguj',
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
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
                          buildNavigationItem("moje parkingi", 0),
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
        body: SafeArea(child: tabs[selectedIndex]));
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
              height: MediaQuery.of(context).size.height / 24,
              decoration: BoxDecoration(
                color: index == selectedIndex
                    ? const Color(0xff072338)
                    : Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
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
                    color: index == selectedIndex ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Jaldi'),
              ),
            )));
  }
}
