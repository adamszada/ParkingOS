import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                                const SizedBox(height: 24),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.height / 20,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/home');
                                      },
                                      
                                      style: ElevatedButton.styleFrom().copyWith(
                                        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                                          (states) {
                                            if (states.contains(MaterialState.hovered)) {
                                              return const Color(0xFF11558A);
                                            } else {
                                              return const Color(0xFF0C3C61);
                                            }
                                          },
                                        ),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(30.0),
                                            )
                                        )
                                      ),

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
