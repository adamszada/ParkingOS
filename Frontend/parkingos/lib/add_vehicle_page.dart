import 'package:flutter/material.dart';

class AddVehiclePage extends StatefulWidget {
  @override
  _AddVehiclePageState createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
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
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    "Dodawanie pojazdu",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 20,
                        color: const Color(0xFF0C3C61),
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Jaldi'),
                  ),
                ),
                Container(
                    decoration: BoxDecoration(
                        color: const Color(0xffF0F0F0),
                        borderRadius: BorderRadius.circular(50)),
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
                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'rejestracja',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color(0xff0C3C61),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                TextField(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'marka',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color(0xff0C3C61),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                TextField(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'model',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color(0xff0C3C61),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                TextField(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                )
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
                                  "dodaj pojazd",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              40,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Jaldi'),
                                ),
                              )))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    "Moje pojazdy:",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 20,
                        color: const Color(0xFF0C3C61),
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Jaldi'),
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
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                buildCarItem(index),
                                buildCarItem(index),
                                buildCarItem(index)
                              ],
                            ),
                          );
                        },
                      )),
                ))
              ],
            )));
  }

  Widget buildCarItem(int index) {
    return Expanded(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xff156BAD),
            borderRadius: BorderRadius.circular(25)),
        child: Text(
          'Element $index',
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    ));
  }
}
