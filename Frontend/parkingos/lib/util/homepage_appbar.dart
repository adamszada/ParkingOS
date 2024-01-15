import 'package:flutter/material.dart';

class HomePageAppBar extends StatelessWidget implements PreferredSize {
  const HomePageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 9,
      width: MediaQuery.of(context).size.width,
      child: Container(
          color: Colors.transparent,
          child: SafeArea(
              child: Container(
            margin: const EdgeInsets.only(top: 20),
            // color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.width / 2,
                    width: MediaQuery.of(context).size.width / 2,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width / 20),
                      child: Image.asset(
                        'assets/parking.png',
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.fitHeight,
                      ),
                    )),
                SizedBox(
                    height: MediaQuery.of(context).size.width / 2,
                    width: MediaQuery.of(context).size.width / 2,
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width / 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: const Text(
                              'Zaloguj się',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black),
                            ),
                          ),
                          Text(
                            '|',
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.height / 45),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: const Text(
                              'Dołącz do nas',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    )),
              ],
            ),
          ))),
    );
  }

  @override
  Widget get child => throw UnimplementedError();

  @override
  Size get preferredSize => const Size(
        double.maxFinite,
        double.maxFinite,
      );
}
