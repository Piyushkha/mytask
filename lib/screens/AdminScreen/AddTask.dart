import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mytask/helper/TextStyle.dart';
import 'package:mytask/helper/Urls.dart';
import 'package:mytask/models/AddUserTasks.dart';
import 'package:http/http.dart' as http;
import 'package:mytask/screens/AdminScreen/AdminScreen.dart';

class AddTask extends StatefulWidget {
  AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  File? imageTemporary;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      imageTemporary = File(image.path);
      setState(() {
        // this = imageTemporary;
      });
    } on PlatformException catch (e) {
      print("Faild to pick image : $e");
    }
  }

  Future pickImagecam() async {
    try {
      final camimage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (camimage == null) return;
      imageTemporary = File(camimage.path);
      setState(() {
        //  = imageTemporary;
      });
    } on PlatformException catch (e) {
      print("Faild to pick image : $e");
    }
  }

  late Future<AddUserstasks> _listUsers;

  @override
  void initState() {
    _listUsers = _futureuser();
    super.initState();
  }

  final taskName = TextEditingController();
  final taskdec = TextEditingController();
  final taskformul = TextEditingController();
  final taskstartDate = TextEditingController();
  final taskEndDate = TextEditingController();

  var dropdownname;
  var dropdownId;
  bool isLoading = false;
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade200,
      appBar: AppBar(
        title: Text("Add Task"),
      ),
      body: isLoading == true
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _key,
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50)),
                      width: double.infinity,
                      child: TextFormField(
                        controller: taskName,
                        validator: (value) {
                          if (value!.isEmpty || value == "") {
                            return "Task Name is Required";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: "Task Name",
                            contentPadding: EdgeInsets.only(left: 10)),
                      )),
                  Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                      height: 150,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      width: double.infinity,
                      child: TextFormField(
                        controller: taskdec,
                        validator: (value) {
                          if (value!.isEmpty || value == "") {
                            return "Task Description is Required";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: "Task Descrption",
                            contentPadding: EdgeInsets.only(left: 10)),
                      )),
                  Container(
                      margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50)),
                      width: double.infinity,
                      child: TextFormField(
                        controller: taskformul,
                        validator: (value) {
                          if (value!.isEmpty || value == "") {
                            return "Task Formula is Required";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: "Task Formula",
                            contentPadding: EdgeInsets.only(left: 10)),
                      )),
                  Container(
                      margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50)),
                      width: double.infinity,
                      child: TextFormField(
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
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
                              taskstartDate.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          } else {}
                        },
                        controller: taskstartDate,
                        validator: (value) {
                          if (value!.isEmpty || value == "") {
                            return "Task Start Date is Required";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.calendar_month),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: "Task Start Date",
                            contentPadding: EdgeInsets.only(left: 10, top: 15)),
                      )),
                  Container(
                      margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50)),
                      width: double.infinity,
                      child: TextFormField(
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
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
                              taskEndDate.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          } else {}
                        },
                        controller: taskEndDate,
                        validator: (value) {
                          if (value!.isEmpty || value == "") {
                            return "Task End Date is Required";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.calendar_month),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: "Task Start Date",
                            contentPadding: EdgeInsets.only(left: 10, top: 15)),
                      )),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                    height: 20,
                    child: Text(
                      "Document*only(png,jpeg,jpg)",
                      style: AddFriendsStyle.profileText1,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _dialogCall(context);
                    },
                    child: Container(
                        height: 200,
                        margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            image: imageTemporary == null
                                ? DecorationImage(
                                    image:
                                        AssetImage("assets/icon/imageBg.png"),
                                    fit: BoxFit.contain)
                                : DecorationImage(
                                    image: FileImage(imageTemporary!),
                                    fit: BoxFit.fill))),
                  ),
                  FutureBuilder<AddUserstasks>(
                      future: _listUsers,
                      builder: (context, snapshot) {
                        return Container(
                          margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)),
                          width: double.infinity,
                          child: DropdownButtonFormField<User>(
                              iconSize: 0,
                              decoration: InputDecoration(
                                  suffixIcon: snapshot.hasData
                                      ? Icon(Icons.arrow_drop_down_outlined)
                                      : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircularProgressIndicator(),
                                        ),
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                  hintText: "Task Assign Users",
                                  contentPadding:
                                      EdgeInsets.only(left: 10, top: 15)),
                              items: snapshot.hasData
                                  ? List.generate(
                                      snapshot.data!.users.length,
                                      (index) => DropdownMenuItem<User>(
                                          value: snapshot.data!.users[index],
                                          child: Text(snapshot
                                              .data!.users[index].username)))
                                  : [],
                              onChanged: (value) {
                                if (mounted)
                                  setState(() {
                                    dropdownname = value?.username.toString();
                                    dropdownId = value?.id.toString();
                                  });
                              }),
                        );
                      }),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50)),
                    margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: ElevatedButton(
                        onPressed: () {
                          if (_key.currentState!.validate()) {
                            if (imageTemporary == null) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("Example Image is Required"),
                                backgroundColor: Colors.red,
                              ));
                            } else {
                              setState(() {
                                isLoading = true;
                              });
                              _addTask();
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(primary: Colors.black),
                        child: Text("Add Task")),
                  ),
                  SizedBox(
                    height: 50,
                  )
                ],
              )),
    );
  }

  Future<AddUserstasks> _futureuser() async {
    AddUserstasks users;
    final response = await http.post(Uri.parse(getUser));
    var decodedata = jsonDecode(response.body);
    // print(decodedata);
    users = AddUserstasks.fromJson(decodedata);
    return users;
  }

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

  Future<void> _addTask() async {
    print("aa gya");
    var request = http.MultipartRequest("POST", Uri.parse(addtask));

    request.files.add(await http.MultipartFile.fromPath(
        "taskExampleImage", imageTemporary!.path));
    request.fields['taskName'] = taskName.text;
    request.fields['taskDec'] = taskdec.text;
    request.fields['taskStartDate'] = taskstartDate.text;
    request.fields['taskEndDate'] = taskEndDate.text;
    request.fields['formula'] = taskformul.text;
    request.fields['taskAssignUsername[userName]'] = dropdownname.toString();
    request.fields['taskAssignUsername[userId]'] = dropdownId.toString();

    var res = await request.send();
    var response = await http.Response.fromStream(res);
    String data = response.body;
    // print('Respose is${data}');
    var resData = jsonDecode(response.body);

    if (resData['message'] == "Task Added") {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(resData['message'].toString()),
        backgroundColor: Colors.green,
      ));
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AdminScreen()));
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }
}
