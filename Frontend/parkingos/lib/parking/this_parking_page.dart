import 'package:flutter/material.dart';
import 'package:parkingos/util/parking_lot.dart';

class ThisParkingPage extends StatefulWidget {
  final ParkingLot parking;
  const ThisParkingPage({super.key, required this.parking});

  @override
  ThisParkingPageState createState() =>
      ThisParkingPageState(parking: this.parking);
}

class ThisParkingPageState extends State<ThisParkingPage> {
  final ParkingLot parking;
  ThisParkingPageState({required this.parking});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      parking.name,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height <
                                  MediaQuery.of(context).size.width
                              ? MediaQuery.of(context).size.height / 15
                              : MediaQuery.of(context).size.width / 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Jaldi'),
                    ),
                    GestureDetector(
                      onTap: () {
                        // [TO DO edycja]
                      },
                      child: Container(
                        child: Text(
                          "edytuj",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height <
                                    MediaQuery.of(context).size.width
                                ? MediaQuery.of(context).size.height / 25
                                : MediaQuery.of(context).size.width / 25,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Jaldi',
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                            decorationThickness: 3.0,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height / 128,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "adres parkingu:",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height <
                                  MediaQuery.of(context).size.width
                              ? MediaQuery.of(context).size.height / 22
                              : MediaQuery.of(context).size.width / 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Jaldi'),
                    ),
                    Text(
                      parking.address,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height <
                                  MediaQuery.of(context).size.width
                              ? MediaQuery.of(context).size.height / 22
                              : MediaQuery.of(context).size.width / 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Jaldi'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "godziny funkcjonowania:",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height <
                                  MediaQuery.of(context).size.width
                              ? MediaQuery.of(context).size.height / 22
                              : MediaQuery.of(context).size.width / 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Jaldi'),
                    ),
                    Text(
                      parking.operatingHours,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height <
                                  MediaQuery.of(context).size.width
                              ? MediaQuery.of(context).size.height / 22
                              : MediaQuery.of(context).size.width / 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Jaldi'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "liczba miejsc:",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height <
                                  MediaQuery.of(context).size.width
                              ? MediaQuery.of(context).size.height / 22
                              : MediaQuery.of(context).size.width / 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Jaldi'),
                    ),
                    Text(
                      "${parking.capacity}",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height <
                                  MediaQuery.of(context).size.width
                              ? MediaQuery.of(context).size.height / 22
                              : MediaQuery.of(context).size.width / 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Jaldi'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "liczba pięter:",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height <
                                  MediaQuery.of(context).size.width
                              ? MediaQuery.of(context).size.height / 22
                              : MediaQuery.of(context).size.width / 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Jaldi'),
                    ),
                    Text(
                      "[TO DO]",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height <
                                  MediaQuery.of(context).size.width
                              ? MediaQuery.of(context).size.height / 22
                              : MediaQuery.of(context).size.width / 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Jaldi'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "miejsca na piętro:",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height <
                                  MediaQuery.of(context).size.width
                              ? MediaQuery.of(context).size.height / 22
                              : MediaQuery.of(context).size.width / 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Jaldi'),
                    ),
                    Text(
                      "[TO DO]",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height <
                                  MediaQuery.of(context).size.width
                              ? MediaQuery.of(context).size.height / 22
                              : MediaQuery.of(context).size.width / 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Jaldi'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "dzienna taryfa:",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height <
                                  MediaQuery.of(context).size.width
                              ? MediaQuery.of(context).size.height / 22
                              : MediaQuery.of(context).size.width / 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Jaldi'),
                    ),
                    Text(
                      "${parking.dayTariff} zł/h",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height <
                                  MediaQuery.of(context).size.width
                              ? MediaQuery.of(context).size.height / 22
                              : MediaQuery.of(context).size.width / 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Jaldi'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "nocna taryfa:",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height <
                                  MediaQuery.of(context).size.width
                              ? MediaQuery.of(context).size.height / 22
                              : MediaQuery.of(context).size.width / 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Jaldi'),
                    ),
                    Text(
                      "${parking.nightTariff} zł/h",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height <
                                  MediaQuery.of(context).size.width
                              ? MediaQuery.of(context).size.height / 22
                              : MediaQuery.of(context).size.width / 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Jaldi'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
