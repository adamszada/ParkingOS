import 'package:flutter/material.dart';

class ParkingLot {
  final String title;
  final String tariffOne;
  final String tariffTwo;
  final String address;
  final String operatingHours;
  final String rules;

  ParkingLot({
    required this.title,
    required this.tariffOne,
    required this.tariffTwo,
    required this.address,
    required this.operatingHours,
    required this.rules,
  });
}

class FindParkingPage extends StatefulWidget {
  @override
  _ParkingLotsPageState createState() => _ParkingLotsPageState();
}

  final List<ParkingLot> parkingLots = [
    ParkingLot(
      title: 'Słoneczny parking',
      tariffOne: '3.5',
      tariffTwo: '6.9',
      address: 'Łódź, Żwirki 26/7',
      operatingHours: '24h/7',
      rules: 'umyj auto',
    ),
        ParkingLot(
      title: 'Słoneczny parking 2 ',
      tariffOne: '3.5',
      tariffTwo: '6.9',
      address: 'Łódź, Żwirki 26/7',
      operatingHours: '24h/7',
      rules: 'umyj auto',
    ),
        ParkingLot(
      title: 'Słoneczny parking 3',
      tariffOne: '3.5',
      tariffTwo: '6.9',
      address: 'Łódź, Żwirki 26/7',
      operatingHours: '24h/7',
      rules: 'umyj auto',
    ),
    // Add more parking lots here...
  ];

class _ParkingLotsPageState extends State<FindParkingPage> {
  int _selectedIndex = 0;
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
                    padding: const EdgeInsets.only(left: 10),
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
                                Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 24,
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: Row(
                                      children: [
                                        buildNavigationItem(
                                            "Znajdź najbliższy", 0),
                                        buildNavigationItem(
                                            "Znajdź najtańszy", 1),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 25),
                                  decoration: const BoxDecoration(
                                    color: Color(0xff072338),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(50),
                                      bottomRight: Radius.circular(50),
                                      topRight: Radius.circular(50),
                                    ),
                                  ),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Adres',
                                      filled: true,
                                      fillColor: Colors
                                          .white, // This is the TextField's color
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 10.0),
                                    ),
                                  ),
                                ),
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
                          child: Padding(padding: EdgeInsets.symmetric(horizontal: 30),
                          child: ElevatedButton(
                              onPressed: () {},
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
                                  "Szukaj",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              40,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Jaldi'),
                                ),
                              )),))
                    ],
                  ),
                ),
                Expanded(
                    child: Container(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                buildCarItem(index, 0),
                                buildCarItem(index, 1),
                                buildCarItem(index, 2)
                              ],
                            ),
                          );
                        },
                      )),
                ))
              ],
            )));
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
                    ? const Color(0xFF072338)
                    : Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
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


 Widget buildCarItem(int index, int rowIndex) {
    if (index * 3 + rowIndex >= parkingLots.length) {
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
                        parkingLots[index * 3 + rowIndex].title,
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
                        parkingLots[index * 3 + rowIndex].tariffOne,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height / 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Jaldi'),
                      ),
                      Text(
                        parkingLots[index * 3 + rowIndex].tariffTwo,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height / 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Jaldi'),
                      ),
                      Text(
                        parkingLots[index * 3 + rowIndex].address,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height / 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Jaldi'),
                      ),
                      Text(
                        parkingLots[index * 3 + rowIndex].operatingHours,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height / 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Jaldi'),
                      ),
                      Text(
                        parkingLots[index * 3 + rowIndex].rules,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height / 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Jaldi'),
                      ),
                    ],
                  ),
                ],
              ))),
    ));
  }
}
