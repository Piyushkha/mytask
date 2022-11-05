import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytask/helper/LocalData_pers.dart';
import 'package:mytask/screens/AdminScreen/AdminScreen.dart';
import 'package:mytask/screens/AuthScreen/Authscreen.dart';
import 'package:mytask/screens/MainScreen/HomeScreen.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String email = "";
  localData() async {
    final pers = await SharedPreferences.getInstance();
    if (mounted)
      setState(() {
        email = pers.getString(Shareper.email) ?? "";
      });
    print(email);
  }

  @override
  void initState() {
    super.initState();
    localData();
    Timer(
        Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => email == "" || email.isEmpty
                ? AuthScreen()
                : email == "admin@gmail.com"
                    ? AdminScreen()
                    : Homescreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FlutterLogo(
              size: 50,
            ),
            SizedBox(height: 15),
            Text(
              "mytask",
              style:
                  GoogleFonts.fuzzyBubbles(fontSize: 22, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
