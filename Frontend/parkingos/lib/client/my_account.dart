import 'package:flutter/material.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 5 / 7,
              height: MediaQuery.of(context).size.height * 5 / 14,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: const Color(0xffF0F0F0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Row(
                      // mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "[login]",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height / 20,
                                    color: const Color(0xFF0C3C61),
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Jaldi'),
                              ),
                              Text(
                                "e-mail:",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height / 30,
                                    color: const Color(0xFF0C3C61),
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Jaldi'),
                              ),
                              Text(
                                "bennymaly@gmail.com",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height / 30,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Jaldi'),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 30, top: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/changeemail');
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
                                        "zmień e-mail",
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                30,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontFamily: 'Jaldi'),
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 30, top: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/newpassword');
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
                                        "zmień hasło",
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                30,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontFamily: 'Jaldi'),
                                      ),
                                    ))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Saldo:",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height / 20,
                                    color: const Color(0xFF0C3C61),
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Jaldi'),
                              ),
                              Text(
                                "[saldo] zł",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height / 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Jaldi'),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/topup');
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
                                        "doładuj saldo",
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                30,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontFamily: 'Jaldi'),
                                      ),
                                    ))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          )
        ]));
  }
}
