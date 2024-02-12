import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'globals.dart' as globals;


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String errorMessage = '';

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  Future<void> loginUser() async {
    final String url = 'http://127.0.0.1:5000/login';

    if (!isValidEmail(emailController.text)) {
      setState(() {
        errorMessage = 'Wprowadzono nieprawidłowy adres e-mail.';
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': emailController.text,
          'password': passwordController.text,
        }),
      );

      if (response.statusCode == 200) {

        Map<String, dynamic> jsonResponse = json.decode(response.body);

        globals.userID = jsonResponse['user_id'];
        globals.currentUser = emailController.text;

        print("User successfully logged in.");
        
        if(globals.currentUser == 'admin@admin.admin')
          Navigator.pushNamed(context, '/owner');
        else
          Navigator.pushNamed(context, '/home');
        
      } else if (response.statusCode == 400) {
        setState(() {
          errorMessage = 'Nieprawidłowe dane logowania.';
        });
      } else {
        setState(() {
          errorMessage = 'Błąd podczas logowania.';
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        errorMessage = 'Błąd podczas wysyłania żądania.';
      });
    }
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
                      "Logowanie",
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
                                    child: Text('login:',
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
                                  controller: emailController,
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
                                    child: Text('hasło:',
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
                                  controller: passwordController,
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
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/recovery');
                                      },
                                      child: Text(
                                        'zapomniałem/am hasła',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: const Color(0xFF0C3C61),
                                            fontFamily: "Jaldi",
                                            fontWeight: FontWeight.w900,
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                45),
                                      ),
                                    ),
                                  ),
                                ),
                                if (errorMessage.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
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
                                const SizedBox(height: 24),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.height / 20,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        loginUser();
                                      },
                                      style: ElevatedButton.styleFrom()
                                          .copyWith(
                                              backgroundColor:
                                                  MaterialStateProperty
                                                      .resolveWith<Color?>(
                                                (states) {
                                                  if (states.contains(
                                                      MaterialState.hovered)) {
                                                    return const Color(
                                                        0xFF11558A);
                                                  } else {
                                                    return const Color(
                                                        0xFF0C3C61);
                                                  }
                                                },
                                              ),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              ))),
                                      child: Text(
                                        'zaloguj',
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
                                const SizedBox(height: 16),
                              ]))),
                )
              ],
            ))
          ],
        ));
  }
}
