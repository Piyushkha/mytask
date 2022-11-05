import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mytask/helper/Colors.dart';
import 'package:mytask/helper/LocalData_pers.dart';
import 'package:mytask/helper/Urls.dart';
import 'package:mytask/screens/AuthScreen/LoginScreen.dart';
import 'package:mytask/screens/MainScreen/HomeScreen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  String? email;
  String? userName;
  String? password;
  String? otp;

  OtpScreen({Key? key, this.email, this.otp, this.password, this.userName})
      : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String OTP = "";
  bool isselect = false;

  final _key = GlobalKey<FormState>();
  // int OTP = 1234;
  TextEditingController textEditingController = TextEditingController();

  final _otpController = TextEditingController();
  bool _isLoading = false;
  @override
  void initState() {
    OTP = widget.otp.toString();
    super.initState();
  }

  // textDispose() async {
  //   otpController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appColor.screenBackGround,
        body: _isLoading == true
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 25, right: 25),
                child: ListView(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 5,
                      ),
                      Center(
                        child: Text(
                          "Enter OTP ${widget.otp.toString()}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      otpPinField(),
                      // const SizedBox(height: 50),

                      Center(
                        child: const Text(
                          "One time password (OTP) to your Email",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      // Text(
                      //   "(OTP) ${"widget.otp"}",
                      //   style: TextStyle(
                      //       color: Colors.white,
                      //       fontSize: 15,
                      //       fontWeight: FontWeight.w700),
                      // ),
                      const SizedBox(height: 10),
                      SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () async {
                                // final prefs = await SharedPreferences.getInstance();
                                // prefs.setBool(Share.isLogin, true);

                                if (_key.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  signup();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.white, width: 2),
                                      borderRadius: BorderRadius.circular(20))
                                  // onPrimary: Colors.black,
                                  ),
                              child: const Text("CONTINUE")))
                    ])));
  }

  Future<void> signup() async {
    try {
      final response = await http.post(Uri.parse(signUp), body: {
        "email": widget.email.toString(),
        "username": widget.userName.toString(),
        "password": widget.password.toString(),
      });
      var responseBody = jsonDecode(response.body);
      print(responseBody);
      if (responseBody['status'] == 200) {
        if (mounted)
          setState(() {
            _isLoading = false;
          });

        final pers = await SharedPreferences.getInstance();
        pers.setString(Shareper.username, widget.userName.toString());
        pers.setString(Shareper.password, widget.password.toString());
        pers.setString(Shareper.email, widget.email.toString());

        // textDispose();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(responseBody['message']),
          backgroundColor: Colors.green,
        ));

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    } catch (e) {
      print(e);
      String message = e.toString();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ));
      // textDispose();
    }
  }

  Widget otpPinField() {
    return Container(
      // color: Colors.black,
      margin: const EdgeInsets.only(top: 40, left: 40, right: 40, bottom: 20),
      child: Form(
        key: _key,
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: PinCodeTextField(
            hintCharacter: '',
            hintStyle: const TextStyle(color: Colors.black),
            length: 4,

            obscureText: false,
            // scrollPadding: EdgeInsets.all(15),
            keyboardType: TextInputType.phone,
            animationType: AnimationType.scale,
            validator: (val) {
              if (val!.isEmpty) {
                return '    Please Enter OTP';
              }
              if (OTP.isNotEmpty && val != OTP) {
                return '    OTP is incorrect';
              }
              if (OTP.isEmpty && val != '1000') {
                return '    OTP is incorrect';
              }
              return null;
            },
            textStyle: const TextStyle(color: Colors.black),
            errorTextSpace: 25,
            pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderWidth: 1.5,
                borderRadius: BorderRadius.circular(8),
                fieldHeight: 45,
                fieldWidth: 45,
                activeFillColor: Colors.white,
                selectedColor: Colors.black,
                selectedFillColor: Colors.grey.shade300,
                inactiveColor: Colors.black,
                disabledColor: Colors.grey.shade400,
                activeColor: Colors.black,
                inactiveFillColor: Colors.grey.shade200,
                errorBorderColor: Colors.red),
            animationDuration: const Duration(milliseconds: 300),
            enableActiveFill: true,
            // errorAnimationController: errorController,
            // controller: textEditingController,
            onCompleted: (v) {
              // _timer.cancel();
              setState(() {
                if (v == OTP) {
                  // isselect = true;
                  // isverify = true;
                }
              });
              print(_otpController.text);
            },
            onChanged: (value) {
              setState(() {
                if (value.length < 4) {
                  isselect = false;
                }
              });
            },
            beforeTextPaste: (text) {
              // print("Allowing to paste $text");
              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
              //but you can show anything you want here, like your pop up saying wrong paste format or etc
              return true;
            },
            appContext: context,
          ),
        ),
      ),
    );
  }
}
