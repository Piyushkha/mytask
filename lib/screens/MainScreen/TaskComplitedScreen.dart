import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mytask/helper/TextStyle.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mytask/screens/MainScreen/ComplitedaTask.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helper/LocalData_pers.dart';
import '../../helper/Urls.dart';
import 'HomeScreen.dart';

class ComplitedTaskVerification extends StatefulWidget {
  String id;
  bool? isfromReject;
  String taskUserId;
  ComplitedTaskVerification(
      {Key? key, required this.id, required this.taskUserId, this.isfromReject})
      : super(key: key);

  @override
  State<ComplitedTaskVerification> createState() =>
      _ComplitedTaskVerificationState();
}

class _ComplitedTaskVerificationState extends State<ComplitedTaskVerification> {
  File? imageTemporary;
  bool isLoading = false;
  final _key = GlobalKey<FormState>();
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

  final taskDecComplited = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(widget.taskUserId);
    return Scaffold(
      body: isLoading == true
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _key,
              child: ListView(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height / 5),
                  Center(
                      child: Text(
                    "Please Verify Your Task",
                    style: AddFriendsStyle.NameStyle,
                  )),
                  GestureDetector(
                    onTap: () {
                      dialogCallImage(context);
                    },
                    child: Container(
                        margin: EdgeInsets.all(15),
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(15),
                          image: imageTemporary == null
                              ? DecorationImage(
                                  image: AssetImage("assets/icon/imageBg.png"),
                                )
                              : DecorationImage(
                                  image: FileImage(imageTemporary!),
                                  fit: BoxFit.fill),
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.all(15),
                    child: TextFormField(
                      controller: taskDecComplited,
                      validator: (value) {
                        if (value!.isEmpty || value == "") {
                          return "Task Complited Description is Required";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: widget.isfromReject == true
                              ? "Task Reject Description"
                              : "Task Complited Description",
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue))),
                    ),
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                        // color: Colors.white,
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
                              Complitedtask(widget.id, widget.taskUserId);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            primary: widget.isfromReject == true
                                ? Colors.red
                                : Colors.green),
                        child: widget.isfromReject == true
                            ? Text("Reject Task")
                            : Text("Complite Task")),
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                        // color: Colors.white,
                        borderRadius: BorderRadius.circular(50)),
                    margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                            primary: widget.isfromReject == true
                                ? Colors.green
                                : Colors.red,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: widget.isfromReject != true
                                        ? Colors.red
                                        : Colors.green))),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        )),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> Complitedtask(
    String id,
    String taskUserId,
  ) async {
    final pers = await SharedPreferences.getInstance();
    var userName = pers.getString(Shareper.username);
    var userId = pers.getString(Shareper.userid);

    // print(userId);
    try {
      var request = http.MultipartRequest("POST", Uri.parse(updateuserTask));

      request.files.add(await http.MultipartFile.fromPath(
          "taskDoneProfeImage", imageTemporary!.path));
      request.fields['id'] = id;
      request.fields['taskstatus'] =
          widget.isfromReject == true ? "false" : 'true';
      request.fields['userId'] = userId.toString();
      request.fields['userName'] = userName.toString();
      request.fields['taskcomplitedDec'] = taskDecComplited.text;
      request.fields['isTaskReject'] =
          widget.isfromReject == true ? 'true' : "false";

      var res = await request.send();
      var response = await http.Response.fromStream(res);
      String data = response.body;
      // print('Respose is${data}');
      var resData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: widget.isfromReject == true
              ? Text("Your Task has been Rejected")
              : Text(resData['message'].toString()),
          backgroundColor:
              widget.isfromReject == true ? Colors.pink.shade300 : Colors.green,
        ));
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Homescreen()));
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  Future<void> dialogCallImage(BuildContext context) {
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
