import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../globals.dart' as globals;

class AccountPasswordChange extends StatefulWidget {
  const AccountPasswordChange({super.key});

  @override
  _AccountPasswordChangeState createState() => _AccountPasswordChangeState();
}

class _AccountPasswordChangeState extends State<AccountPasswordChange> {
  TextEditingController newpasswordController = TextEditingController();
  TextEditingController newpassword2Controller = TextEditingController();
  String errorMessage = '';

  Future<void> changePassword() async {
    String password = newpasswordController.text;
    String email = globals.currentUser;

    final response = await http.post(
      Uri.parse("http://127.0.0.1:5000/change_password"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "new_password": password}),
    );

            final Map<String, dynamic> data = jsonDecode(response.body);
        errorMessage = data['message'];
    setState(() {
      if (response.statusCode == 200) {

        print(errorMessage);
        //errorMessage = 'Hasło zmienione poprawnie.';
      } else {
        errorMessage = data['message'];
      }
    });
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
                      "Odzyskiwanie konta",
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
                                    child: Text('nowe hasło:',
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
                                  obscureText: true,
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
                                    child: Text('powtórz nowe hasło:',
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
                                  obscureText: true,
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
                                      onPressed: () {
                                        if (newpasswordController.text != '' &&
                                            newpassword2Controller.text != '') {
                                          if (newpasswordController.text ==
                                              newpassword2Controller.text) {
                                            changePassword();
                                          } else {
                                            setState(() {
                                              errorMessage =
                                                  "Hasła nie są jednakowe!!!";
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            errorMessage = "Podaj oba hasła!!!";
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
                                        'Zmień hasło',
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
