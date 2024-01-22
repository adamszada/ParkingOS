import 'package:flutter/material.dart';
import 'package:parkingos/change_email.dart';
import 'package:parkingos/email_recovery.dart';
import 'package:parkingos/base_screen.dart';
import 'package:parkingos/login_page.dart';
import 'package:parkingos/my_account.dart';
import 'package:parkingos/owner_screen.dart';
import 'package:parkingos/register_page.dart';
import 'package:parkingos/account_pass_change.dart';
import 'package:parkingos/top_up.dart';
import 'package:parkingos/util/homepage_appbar.dart';
import 'util/wave_painter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ParKing',
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/recovery': (context) => const EmailRecovery(),
        '/newpassword': (context) => const AccountPasswordChange(),
        '/myaccount': (context) => const MyAccount(),
        '/topup': (context) => const TopUp(),
        '/changeemail': (context) => const ChangeEmail(),
        '/home': (context) => const BaseScreen(),
        '/owner': (context) => const OwnerScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomePageAppBar(),
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
                  )),
            ],
          )
        ],
      ),
    );
  }
}
