import 'package:flutter/material.dart';

class AddParkingScreen extends StatefulWidget {
  const AddParkingScreen({super.key});

  @override
  _AddParkingScreenState createState() => _AddParkingScreenState();
}

class _AddParkingScreenState extends State<AddParkingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height / 32,
                horizontal: MediaQuery.of(context).size.width / 32),
            child: SizedBox.expand(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dodawanie parkingu',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Color(0xff0C3C61),
                        fontWeight: FontWeight.w900,
                        fontSize: MediaQuery.of(context).size.height / 24),
                  ),
                  Expanded(
                    child: Container(color: Colors.red),
                  )
                ],
              ),
            )));
  }
}
