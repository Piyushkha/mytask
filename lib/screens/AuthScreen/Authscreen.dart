import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/helper/Colors.dart';
import '/screens/AuthScreen/LoginScreen.dart';
import '/screens/AuthScreen/SignUp.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor.screenBackGround,
      body: Center(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Column(
            children: [
              FlutterLogo(
                size: 50,
              ),
              SizedBox(height: 15),
              Text(
                "MYBOOK",
                style:
                    GoogleFonts.fuzzyBubbles(fontSize: 22, color: Colors.white),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 15, right: 15, top: 5),
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SignUpScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(20))),
                    child: Text("SIGN UP")),
              ),
              Container(
                  margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Colors.black,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(20))),
                      child: Text("LOGIN"))),
            ],
          )
        ]),
      ),
    );
  }
}
