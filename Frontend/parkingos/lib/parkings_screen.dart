import 'package:flutter/material.dart';
import 'package:parkingos/util/parking_lot.dart';

class ParkingsScreen extends StatefulWidget {
  const ParkingsScreen({super.key});

  @override
  _ParkingsScreenState createState() => _ParkingsScreenState();
}

List<ParkingLot> parkingLots = [
  ParkingLot(
    name: "Parking Centralny",
    address: "ul. Główna 1, 00-001 Warszawa",
    capacity: 15,
    dayTariff: 10.0,
    nightTariff: 5.0,
  ),
  ParkingLot(
    name: "Parking Południowy",
    address: "ul. Słoneczna 5, 00-002 Kraków",
    capacity: 20,
    dayTariff: 12.0,
    nightTariff: 6.0,
  ),
  ParkingLot(
    name: "Parking Zachodni",
    address: "ul. Kwiatowa 10, 00-003 Gdańsk",
    capacity: 25,
    dayTariff: 8.0,
    nightTariff: 4.0,
  ),
];

class _ParkingsScreenState extends State<ParkingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: MediaQuery.of(context).size.height / 5,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height / 64),
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 128),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: const Color(0xff072338),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "suma\nzarobków",
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height / 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Jaldi',
                                  height: 1,
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "1200zł",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              8,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Jaldi',
                                      height: 1),
                                ),
                              )
                            ],
                          )),
                    ),
                  )),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 128),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: const Color(0xff072338),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "średnie zarobki\nna godzine",
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height / 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Jaldi',
                                  height: 1,
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "120zł/h",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              8,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Jaldi',
                                      height: 1),
                                ),
                              )
                            ],
                          )),
                    ),
                  )),
                ],
              ),
            )),
        Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 128,
              width: MediaQuery.of(context).size.width * 51 / 52,
              child: Container(
                color: const Color(0xff072338),
              ),
            )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Text(
                "Moje parkingi: ",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height / 20,
                    color: const Color(0xFF0C3C61),
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Jaldi'),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xff156BAD), // Kolor tła przycisku
                    shape: BoxShape.circle, // Okrągły kształt
                  ), // Padding wewnątrz Containera
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 50, // Kolor ikony
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: parkingLots.length % 2 != 0
                      ? parkingLots.length ~/ 2 + 1
                      : parkingLots.length ~/ 2,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          buildParkingLotItem(index, 0),
                          buildParkingLotItem(index, 1),
                        ],
                      ),
                    );
                  },
                )))
      ],
    );
  }

  Widget buildParkingLotItem(int index, int rowIndex) {
    if (index * 2 + rowIndex >= parkingLots.length) {
      return Expanded(child: Container());
    }
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
                        parkingLots[index * 2 + rowIndex].name,
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
                        parkingLots[index * 2 + rowIndex].capacity.toString(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height / 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Jaldi'),
                      ),
                      Text(
                        parkingLots[index * 2 + rowIndex].address,
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
                            parkingLots.removeAt(index * 2 + rowIndex);
                          });
                        },
                      ))
                ],
              ))),
    ));
  }
}