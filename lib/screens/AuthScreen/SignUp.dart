import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytask/helper/Colors.dart';
import 'package:mytask/helper/Urls.dart';
import 'package:mytask/main.dart';
import 'package:http/http.dart' as http;
import 'package:mytask/screens/AuthScreen/LoginScreen.dart';
import 'package:mytask/screens/AuthScreen/OtpScreen.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _key = GlobalKey<FormState>();
  var Otp;
  final email = TextEditingController();
  final username = TextEditingController();

  final password = TextEditingController();

  bool _isLoading = false;
  bool _isLoading2 = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email;
    username;
    password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor.screenBackGround,
      body: _isLoading == true
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _key,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 50),
                      FlutterLogo(
                        size: 50,
                      ),
                      SizedBox(height: 15),
                      Center(
                        child: Text(
                          "mytask",
                          style: GoogleFonts.fuzzyBubbles(
                              fontSize: 22, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        controller: username,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Username";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            label: Text(
                              "USERNAME",
                              style: TextStyle(color: Colors.white),
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2)),
                            disabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2))),
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        controller: email,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Your Email";
                          } else if (!value.contains("@")) {
                            return "Please Enter Valid Your Email";
                          } else if (!value.contains(".com")) {
                            return "Please Enter Valid Your Email";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            label: Text(
                              "EMAIL",
                              style: TextStyle(color: Colors.white),
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2)),
                            disabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2))),
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        controller: password,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.remove_red_eye,
                                color: Colors.white,
                              ),
                            ),
                            label: Text(
                              "PASSWORD",
                              style: TextStyle(color: Colors.white),
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2)),
                            disabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2))),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Forgot Password",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 25),
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              if (_key.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });
                                checkEmail(email.text);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                onPrimary: Colors.black,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.white, width: 2),
                                    borderRadius: BorderRadius.circular(20))),
                            child: Text("SIGN UP")),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            height: 1.5,
                            width: 140,
                            color: Colors.white,
                          ),
                          Text(
                            "   Or   ",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          Container(
                            height: 1.5,
                            width: 140,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                          },
                          child: Text(
                            "LOGIN",
                            style: TextStyle(color: Colors.white),
                          ))
                    ]),
              ),
            ),
    );
  }

  Future<void> checkEmail(String email) async {
    try {
      final response = await http
          .post(Uri.parse(checkEmails), body: {"email": email.toString()});
      var responseBody = jsonDecode(response.body);
      print(responseBody);
      if (responseBody['status'] == 200) {
        print("object");
        _otpAPi(email);
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(responseBody['message'].toString()),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print(e);

      String message = e.toString();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _otpAPi(String email) async {
    try {
      final response =
          await http.post(Uri.parse(otp), body: {"email": email.toString()});
      var responseBody = jsonDecode(response.body);
      print(responseBody);
      if (responseBody['status'] == 200) {
        setState(() {
          _isLoading = false;

          // isOtpOnLogin = true;
          Otp = responseBody['otp'].toString();
        });

        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => OtpScreen(
                  email: email,
                  password: password.text,
                  otp: Otp,
                  userName: username.text,
                )));
      }
    } catch (e) {
      print(e);
      String message = e.toString();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ));
    }
  }
}
