import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../globals.dart' as globals;

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({super.key});

  @override
  _ChangeEmailState createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
 TextEditingController newpasswordController = TextEditingController();
  TextEditingController newpassword2Controller = TextEditingController();
  String errorMessage = '';

  Future<bool> changePassword() async {
    String old_email = globals.currentUser;
    String new_email = newpasswordController.text;
    bool check = false;
    final response = await http.post(
      Uri.parse("http://127.0.0.1:5000/change_email"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"old_email": old_email, "new_email": new_email}),
    );

            final Map<String, dynamic> data = jsonDecode(response.body);
        errorMessage = data['message'];
    setState(() {
      if (response.statusCode == 200) {

        print(errorMessage);
        globals.currentUser = new_email;
        check = true;
        //errorMessage = 'Hasło zmienione poprawnie.';
      } else {
        errorMessage = data['message'];
      }
    });
    return check;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                  width: MediaQuery.of(context).size.width / 6,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 50,
                        top: MediaQuery.of(context).size.width / 50),
                    child: Image.asset(
                      'assets/parking.png',
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.fitWidth,
                    ),
                  )),
            ),
            Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width * 5 / 17,
                    child: Text(
                      "Zmień e-mail",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 20,
                          color: const Color(0xFF0C3C61),
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Jaldi'),
                    )),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(50)),
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('nowy e-mail:',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: const Color(0xFF0C3C61),
                                            fontFamily: "Jaldi",
                                            fontWeight: FontWeight.w900,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                45)),
                                  ),
                                ),
                                TextField(
                                  controller: newpasswordController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('powtórz nowy e-mail:',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: const Color(0xFF0C3C61),
                                            fontFamily: "Jaldi",
                                            fontWeight: FontWeight.w900,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                45)),
                                  ),
                                ),
                                TextField(
                                  controller: newpassword2Controller,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.height / 20,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (newpasswordController.text != '' &&
                                            newpassword2Controller.text != '') {
                                          if (newpasswordController.text ==
                                              newpassword2Controller.text) {
                                            if (await changePassword() == true)
                                              Navigator.pushNamed(context, '/home');
                                          } else {
                                            setState(() {
                                              errorMessage =
                                                  "Maile nie są jednakowe!!!";
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            errorMessage = "Podaj oba maile!!!";
                                          });
                                        }
                                         
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
                                        'Zmień e-mail',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Jaldi",
                                            fontWeight: FontWeight.w900,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                45),
                                      ),
                                    )),
                                if (errorMessage.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        errorMessage,
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontFamily: "Jaldi",
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              45,
                                        ),
                                      ),
                                    ),
                                  ),
                              ]))),
                )
              ],
            ))
          ],
        ));
  }
}