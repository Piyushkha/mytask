import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mytask/helper/Colors.dart';
import 'package:mytask/helper/LocalData_pers.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:truserves/Urls/Api_urls.dart';
// import 'package:truserves/screens/Helper/color.dart';
// import 'package:truserves/screens/Helper/share_pref.dart';
// import 'package:truserves/screens/HomeScreens.dart/Desboard/DeshboardAppbar.dart';
import 'package:http/http.dart' as http;

// import 'Desboard/Mainscreens.dart';

class ProfileScreen extends StatefulWidget {
  bool? isSidenav;
  ProfileScreen({this.isSidenav, Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // String dropdownvalue = 'Gender';
  TextEditingController dateofbirth = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();
  var userId;
  String profileimage = "";

  localdata() async {
    final pers = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        name.text = pers.getString(Shareper.username) ?? "";
        email.text = pers.getString(Shareper.email) ?? "";
        userId = pers.getString(Shareper.userid) ?? "";

        selectval = pers.getString(Shareper.gender) ?? "";
        dateofbirth.text = pers.getString(Shareper.dob) ?? "";
        profileimage = pers.getString(Shareper.profileImage) ?? "";
      });
    }
    // print(selectval);
    if (selectval == 'male') {
      setState(() {
        selectval = 'Male';
      });
    } else if (selectval == 'female') {
      setState(() {
        selectval = 'Female';
      });
    }
    // print(name.text);
    // print(dateofbirth.toString());
    // profileimage()
  }

  @override
  void initState() {
    super.initState();
    localdata();
  }

  List<String> listitems = ["Male", "Female"];
  var selectval;
  final _formkey = GlobalKey<FormState>();
  File? _image;
  File? imageTemporary;
  File? _camera;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      setState(() {
        imageTemporary = File(image.path);
        // this = imageTemporary;
      });
    } on PlatformException {
      // print("Faild to pick image : $e");
    }
  }

  Future pickImagecam() async {
    try {
      final camimage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (camimage == null) return;
      setState(() {
        imageTemporary = File(camimage.path);
        //  = imageTemporary;
      });
    } on PlatformException catch (e) {
      print("Faild to pick image : $e");
    }
  }

  bool isLoadingData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: appColor.screenBackGround,
      appBar: widget.isSidenav == true
          ? AppBar(
              // title: Text("Profile"),
              // flexibleSpace: CustomAppbarDeshBoard(
              //   selectedindex: 3,
              // ),
              )
          : null,
      body: isLoadingData == true
          ? const Center(child: CircularProgressIndicator())
          : ListView(children: [
              const SizedBox(height: 40),
              GestureDetector(
                  onTap: () {
                    _dialogCall(context);
                    // Navigator.of(context).pop();
                    // print("object");
                  },
                  child: profileimage ==
                              "https://truserves.com/public/backend/images/profiles/" ||
                          profileimage == "" && imageTemporary == null
                      ? const Icon(
                          Icons.person,
                          size: 65,
                        )
                      : profileimage.isNotEmpty &&
                              imageTemporary == null &&
                              profileimage !=
                                  "https://truserves.com/public/backend/images/profiles/"
                          ? Center(
                              child: SizedBox(
                              height: 85,
                              width: 85,
                              child: ClipOval(
                                // decoration: BoxDecoration(shape: BoxShape.circle,borderRadius: BorderRadius.circular(15)),
                                child: CachedNetworkImage(
                                  imageUrl: profileimage,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(
                                    Icons.person,
                                    size: 65,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ))
                          : Center(
                              child: SizedBox(
                              height: 85,
                              width: 85,
                              child: ClipOval(
                                // decoration: BoxDecoration(shape: BoxShape.circle,borderRadius: BorderRadius.circular(15)),
                                child: imageTemporary != null
                                    ? Image(
                                        image: FileImage(imageTemporary!),
                                        fit: BoxFit.cover,
                                      )
                                    : const Center(
                                        child: CircularProgressIndicator()),
                              ),
                            ))),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Name is Empty';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              label: Text(
                                "Name*",
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey.shade700),
                              )),
                        ),
                        TextFormField(
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          readOnly: email.text == '' ? false : true,
                          decoration: InputDecoration(
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              label: Text(
                                "Email*",
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey.shade700),
                              )),
                        ),
                        TextFormField(
                          controller: mobile,
                          keyboardType: TextInputType.number,
                          readOnly: true,
                          decoration: InputDecoration(
                              prefix: const Text("+91 ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16)),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              label: Text(
                                "Mobile Number",
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey.shade700),
                              )),
                        ),
                        DropdownButtonFormField(
                          // value: selectval,

                          decoration: InputDecoration(
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              // hintText: "Gender",
                              label: selectval != ''
                                  ? Text(
                                      selectval.toString(),
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    )
                                  : Text(
                                      "Gender",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade700),
                                    )),
                          onChanged: (value) {
                            if (mounted) {
                              setState(() {
                                // if (selectval.toString().isEmpty) {
                                //   selectval = value.toString();
                                // }
                                selectval = value.toString();
                                // value = selectval.toString();
                              });
                            }
                          },
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: listitems.map((itemone) {
                            return DropdownMenuItem(
                                value: itemone, child: Text(itemone));
                          }).toList(),
                        ),
                        // DropdownButton(items: items, onChanged: onChanged)
                        TextFormField(
                          controller: dateofbirth,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'DOB is Empty';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              label: const Text("Date Of Birth"),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              suffixIcon: Icon(
                                Icons.calendar_month,
                                color: Theme.of(context).primaryColor,
                              )),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2100));

                            if (pickedDate != null) {
                              // print(
                              //     pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              // print(
                              //     formattedDate); //formatted date output using intl package =>  2021-03-16
                              setState(() {
                                dateofbirth.text =
                                    formattedDate; //set output date to TextField value.
                              });
                            } else {}
                          },
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                            height: 40,
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () {
                                  if (_formkey.currentState!.validate()) {
                                    setState(() {
                                      isLoadingData = true;
                                    });
                                    // _updataProfile();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                child: const Text("UPDATE PROFILE")))
                      ],
                    )),
              )
            ]),
    );
  }

  // Future<void> _updataProfile() async {
  //   var req = http.MultipartRequest("POST", Uri.parse(updateProfile));

  //   imageTemporary != null
  //       ? req.files.add(await http.MultipartFile.fromPath(
  //           "profile_image", imageTemporary!.path))
  //       : req.fields['profile_image'] = profileimage;

  //   req.fields['id'] = userId.toString();
  //   req.fields['name'] = name.text;
  //   req.fields['phone'] = mobile.text;
  //   req.fields['email'] = email.text;
  //   req.fields['gender'] = selectval.toString();
  //   req.fields['dob'] = dateofbirth.text;

  //   var res = await req.send();
  //   var response = await http.Response.fromStream(res);

  //   var jsonDecodeData = jsonDecode(response.body);
  //   print(jsonDecodeData);
  //   // print('code${jsonDecodeData}');
  //   if (jsonDecodeData['status'] == 200) {
  //     // print(response.body);
  //     Navigator.of(context).pushReplacement(MaterialPageRoute(
  //         builder: (context) => MainScreens(
  //               selectIndex: 0,
  //             )));
  //     Fluttertoast.showToast(
  //         msg: "Your Profile has been updated sucessfully",
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 1,
  //         textColor: Colors.black,
  //         backgroundColor: Colors.white);
  //     var pers = await SharedPreferences.getInstance();

  //     // setState(() {
  //     isLoadingData = false;

  //     pers.setString(
  //         Share.dob,
  //         dateofbirth.text == ""
  //             ? jsonDecodeData['user']['dob'].toString()
  //             : dateofbirth.text);
  //     pers.setString(
  //         Share.gender,
  //         selectval.toString().isEmpty
  //             ? jsonDecodeData['user']['gender']
  //             : selectval.toString());
  //     pers.setString(Share.profileimage,
  //         jsonDecodeData['user']["profile_image"].toString());
  //     pers.setString(Share.name, name.text);
  //     pers.setString(Share.email, email.text);
  //     pers.setString(Share.dob, dateofbirth.text);

  //     // });
  //     // print(dob);
  //     print('profileImage${jsonDecodeData['user']['dob']}');
  //   } else {
  //     Fluttertoast.showToast(
  //         msg: "Image size is too large",
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 1,
  //         textColor: Colors.black,
  //         backgroundColor: Colors.white);
  //     setState(() {
  //       isLoadingData = false;
  //     });
  //   }
  // }

  Future<void> _dialogCall(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  ListTile(
                      onTap: () {
                        pickImagecam();
                        Navigator.of(context).pop();
                      },
                      title: const Text("Take Photo")),
                  ListTile(
                      onTap: () {
                        pickImage();
                        Navigator.of(context).pop();
                      },
                      title: const Text("Choose from Library")),
                  ListTile(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      title: const Text("Cancel")),
                  // Padding(
                  //   padding: EdgeInsets.all(8.0),
                  // ),
                ],
              ),
            ),
          );
        });
  }
}
