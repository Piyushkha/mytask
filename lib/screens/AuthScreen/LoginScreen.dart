import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytask/screens/AdminScreen/AdminScreen.dart';
import 'package:mytask/screens/MainScreen/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helper/LocalData_pers.dart';
import '/helper/Colors.dart';
import '/screens/AuthScreen/SignUp.dart';
import 'package:http/http.dart' as http;
// import '/screens/Deshboard.dart';

import '../../helper/Urls.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _key = GlobalKey<FormState>();
  bool _isVisible = false;

  bool _isLoading = false;
  final email = TextEditingController();
  final password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor.screenBackGround,
      body: Form(
        key: _key,
        child: _isLoading == true
            ? Center(child: CircularProgressIndicator())
            : Padding(
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
                          "MYBOOK",
                          style: GoogleFonts.fuzzyBubbles(
                              fontSize: 22, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 20),
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
                        obscureText: _isVisible ? false : true,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        controller: password,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Your Password";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isVisible = !_isVisible;
                                });
                              },
                              icon: Icon(
                                _isVisible
                                    ? Icons.remove_red_eye
                                    : Icons.remove_red_eye_outlined,
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
                                login();
                                setState(() {
                                  _isLoading = true;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                onPrimary: Colors.black,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.white, width: 2),
                                    borderRadius: BorderRadius.circular(20))),
                            child: Text("LOGIN")),
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
                                builder: (context) => SignUpScreen()));
                          },
                          child: Text(
                            "SIGN UP",
                            style: TextStyle(color: Colors.white),
                          ))
                    ]),
              ),
      ),
    );
  }

  Future<void> login() async {
    try {
      final response = await http.post(Uri.parse(logins), body: {
        "email": email.text.toString(),
        "password": password.text.toString()
      });
      var responseBody = jsonDecode(response.body);
      print(responseBody);
      if (responseBody['status'] == 200) {
        setState(() {
          _isLoading = false;

          // isOtpOnLogin = true;
        });
        final pers = await SharedPreferences.getInstance();
        pers.setString(
            Shareper.username, responseBody['users']['username'].toString());
        pers.setString(Shareper.password, password.text.toString());
        pers.setString(Shareper.email, email.text.toString());
        pers.setString(Shareper.userid, responseBody['users']['_id']);

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Homescreen()));
        if (responseBody['users']['isadmin'] == true) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => AdminScreen()));
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(responseBody['message'].toString()),
          backgroundColor: Colors.green,
        ));
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
}
