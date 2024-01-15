import 'package:flutter/material.dart';
import 'package:parkingos/change_email.dart';
import 'package:parkingos/email_recovery.dart';
import 'package:parkingos/login_page.dart';
import 'package:parkingos/my_account.dart';
import 'package:parkingos/register_page.dart';
import 'package:parkingos/account_pass_change.dart';
import 'package:parkingos/email_recovery.dart';
import 'package:parkingos/top_up.dart';
import 'package:parkingos/util/homepage_appbar.dart';
import 'util/wave_painter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ParKing',
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/recovery': (context) => EmailRecovery(),
        '/newpassword': (context) => AccountPasswordChange(),
        '/myaccount': (context) => MyAccount(),
        '/topup': (context) => TopUp(),
        '/changeemail': (context) => ChangeEmail(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomePageAppBar(),
      body: Stack(
        children: [
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: WavesPainter(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 20,
                      right: MediaQuery.of(context).size.width / 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Znajdź\nZarezerwuj\nZaparkuj',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width / 12,
                          fontWeight: FontWeight.bold,
                          height: MediaQuery.of(context).size.height /
                              700, // Line height
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 10 / 35,
                        width: MediaQuery.of(context).size.width * 10 / 35,
                        child: Image.asset('assets/short_logo.png'),
                      )
                    ],
                  ))
            ],
          )
        ],
      ),
    );
  }
}
