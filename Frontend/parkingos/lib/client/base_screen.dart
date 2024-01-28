import 'package:flutter/material.dart';
import 'package:parkingos/client/add_vehicle_page.dart';
import 'package:parkingos/client/find_parking_page.dart';
import 'package:parkingos/client/my_account.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  BaseScreenState createState() => BaseScreenState();
}

class BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0;
  final tabs = [
    const MyAccount(),
    const AddVehiclePage(),
    const FindParkingPage()
  ];

  BaseScreenState();
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
                        onPressed: () {},
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
                          buildNavigationItem("moje konto", 0),
                          buildNavigationItem("moje pojazdy", 1),
                          buildNavigationItem("znajdź parking", 2),
                        ],
                      ),
                    )),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 128,
                      child: Container(
                        color: const Color(0xff1A88DB),
                      ),
                    )),
              ],
            )),
        body: SafeArea(child: tabs[_selectedIndex]));
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
                    ? const Color(0xff1A88DB)
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
                    color:
                        index == _selectedIndex ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Jaldi'),
              ),
            )));
  }
}
