import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  bool isPasswordStrong(String password) {
    return password.length >= 8;
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  Future<void> _register() async {
    if (_passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _passwordController.text != _confirmPasswordController.text ||
        !isPasswordStrong(_passwordController.text)) {
      // Nieprawidłowe dane rejestracji - obsługa błędów lub wyświetlenie komunikatu
      return;
    }

    if (isValidEmail(_emailController.text) == false) {
      // Nieprawidłowy adres e-mail
      return;
    }

    final String apiUrl = 'http://127.0.0.1:5000/register';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        <String, dynamic>{
          'email': _emailController.text,
          'password': _passwordController.text,
          'confirmPassword': _confirmPasswordController.text,
        },
      ),
    );

    if (response.statusCode == 200) {
      Navigator.pushNamed(context, '/login');
    } else if (response.statusCode == 400) {
      // Błąd - użytkownik już istnieje
      print('A user with this email already exists.');
    } else {
      // Inny błąd
      print('Error registering user: ${response.body}');
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
                  top: MediaQuery.of(context).size.width / 50,
                ),
                child: Image.asset(
                  'assets/parking.png',
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
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
                      fontFamily: 'Jaldi',
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(50),
                    ),
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
                              child: Text(
                                'e-mail:',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: const Color(0xFF0C3C61),
                                  fontFamily: "Jaldi",
                                  fontWeight: FontWeight.w900,
                                  fontSize:
                                      MediaQuery.of(context).size.height / 45,
                                ),
                              ),
                            ),
                          ),
                          TextField(
                            controller: _emailController,
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
                              child: Text(
                                'hasło:',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: const Color(0xFF0C3C61),
                                  fontFamily: "Jaldi",
                                  fontWeight: FontWeight.w900,
                                  fontSize:
                                      MediaQuery.of(context).size.height / 45,
                                ),
                              ),
                            ),
                          ),
                          TextField(
                            obscureText: true,
                            controller: _passwordController,
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
                              child: Text(
                                'potwierdź hasło:',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: const Color(0xFF0C3C61),
                                  fontFamily: "Jaldi",
                                  fontWeight: FontWeight.w900,
                                  fontSize:
                                      MediaQuery.of(context).size.height / 45,
                                ),
                              ),
                            ),
                          ),
                          TextField(
                            obscureText: true,
                            controller: _confirmPasswordController,
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
                          // Dodaj warunki sprawdzające hasło i potwierdzenie hasła
                          if (_passwordController.text.isNotEmpty &&
                              _confirmPasswordController.text.isNotEmpty)
                            if (_passwordController.text !=
                                _confirmPasswordController.text)
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Hasła nie są identyczne',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontFamily: "Jaldi",
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              45,
                                    ),
                                  ),
                                ),
                              ),
                          if (_passwordController.text.isNotEmpty &&
                              _confirmPasswordController.text.isNotEmpty &&
                              !isPasswordStrong(_passwordController.text))
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Hasło musi być silne',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontFamily: "Jaldi",
                                    fontSize:
                                        MediaQuery.of(context).size.height / 45,
                                  ),
                                ),
                              ),
                            ),
                          if (_emailController.text.isNotEmpty &&
                              !isValidEmail(_emailController.text))
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Wprwoadzono nieprawidłowy adres e-mail',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontFamily: "Jaldi",
                                    fontSize:
                                        MediaQuery.of(context).size.height / 45,
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 20,
                            child: ElevatedButton(
                              onPressed: _register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0C3C61),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              child: Text(
                                'Zarejestruj',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Jaldi",
                                  fontWeight: FontWeight.w900,
                                  fontSize:
                                      MediaQuery.of(context).size.height / 45,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
