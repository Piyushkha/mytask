import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mytask/helper/LocalData_pers.dart';
import 'package:mytask/screens/AdminScreen/TaskDetails.dart';
import 'package:mytask/screens/MainScreen/Drawer.dart';
import 'package:mytask/screens/MainScreen/HomeScreen.dart';
import 'package:mytask/screens/MainScreen/TaskComplitedScreen.dart';
import 'package:mytask/screens/MainScreen/TaskDetailsViews.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/TextStyle.dart';
import 'package:http/http.dart' as http;
import '../../helper/Urls.dart';
import '../../models/UserTasks.dart';

class Mytask extends StatefulWidget {
  Mytask({Key? key}) : super(key: key);

  @override
  State<Mytask> createState() => _MyTasksusertate();
}

class _MyTasksusertate extends State<Mytask> {
  late Future<Tasksuser> _taskUser;
  @override
  void initState() {
    _taskUser = _future();
    // startTimer();

    super.initState();
  }

  int timeDiff = 15;

  timedi(DateTime starttime, DateTime endtime) {
    final birthday = starttime;
    final date2 = endtime;
    final difference = date2.difference(birthday).inSeconds;
    print(difference);

    return difference;
  }

  int indexs = 0;
  int itemCount = 0;
  late Timer _timer;
  int _start = 25;
  void startTimer() {
    var oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // timedi();
    return Scaffold(
        // drawer: DrawerApp(_advancedDrawerController, _advancedDrawerController),
        // extendBodyBehindAppBar: true,
        body: RefreshIndicator(
      displacement: 50,
      backgroundColor: Colors.blue,
      color: Colors.white,
      strokeWidth: 3,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      onRefresh: () async {
        _future();
        await Future.delayed(Duration(milliseconds: 1000));
        setState(() {
          itemCount = itemCount + 1;
        });
      },
      child: FutureBuilder<Tasksuser>(
          future: _taskUser,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.data!.users.isEmpty || snapshot.data == []) {
              return Center(child: Text("New Task Not Found"));
            } else if (snapshot.hasData) {
              return ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.users.length,
                  itemBuilder: (BuildContext context, int index) {
                    indexs = index + 1;
                    var snapdata = snapshot.data!.users[index];
                    var timestart = snapdata.taskStartDate;
                    var timeend = snapdata.taskEndDate;

                    var time = timedi(timestart, timeend);

                    return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (contet) => TaskDetailsViews(
                                    imageUrl: snapdata.taskExampleImage,
                                    daysLeft: time.toString(),
                                    taksFormula: snapdata.formula,
                                    taskDec: snapdata.taskDec,
                                    taskendDate:
                                        snapdata.taskEndDate.toString(),
                                    taskname: snapdata.taskName,
                                    taskstartDate:
                                        snapdata.taskStartDate.toString(),
                                  )));
                        },
                        child: Container(
                          // width: 250,
                          margin: EdgeInsets.only(left: 10, right: 10),
                          height: 70,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // sizebo
                              Wrap(
                                children: [
                                  CircleAvatar(child: Text(indexs.toString())),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            snapdata.taskName,
                                            style: AddFriendsStyle.NameStyle,
                                          ),
                                          SizedBox(width: 30),
                                        ],
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        ' Task End On ${DateFormat('MMM dd, yyyy, HH-mm').format(snapdata.taskEndDate).toString()}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ],
                              ),

                              Container(
                                alignment: Alignment.center,
                                height: 35,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: Colors.red.shade300,
                                    borderRadius: BorderRadius.circular(15)),
                                child: IconButton(
                                    style: IconButton.styleFrom(
                                        // primary: Colors.black,
                                        ),
                                    onPressed: () {
                                      dialogCall(context, snapdata.id,
                                          snapdata.taskAssignUsername[0].id);
                                    },
                                    icon: Icon(Icons.cancel_outlined)),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                width: 50,
                                alignment: Alignment.center,
                                height: 35,
                                decoration: BoxDecoration(
                                    color: Colors.green.shade300,
                                    borderRadius: BorderRadius.circular(15)),
                                child: IconButton(
                                    style: IconButton.styleFrom(
                                        // primary: Colors.black,
                                        ),
                                    onPressed: () {
                                      complitedTask(context, snapdata.id,
                                          snapdata.taskAssignUsername[0].id);
                                    },
                                    icon: Icon(Icons.task_alt_outlined)),
                              ),
                            ],
                          ),
                        ));
                  });
            }
            return Center(child: CircularProgressIndicator());
          }),
    ));
  }

  Future<void> dialogCall(BuildContext context, String id, String taskUserid) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Are You Sure To Reject the Task"),
            // content: Column(
            //   children: [

            //   ],
            // ),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.red,
                    size: 30,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ComplitedTaskVerification(
                              id: id,
                              isfromReject: true,
                              taskUserId: taskUserid,
                            )));
                    // rejectTask(id, taskUserid);
                  },
                  icon: Icon(
                    Icons.verified_rounded,
                    color: Colors.green,
                    size: 30,
                  )),
            ],
          );
        });
  }

  Future<void> complitedTask(
      BuildContext context, String id, String taskUserid) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Are You Sure To Complited the Task"),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.red,
                    size: 30,
                  )),
              IconButton(
                  onPressed: () {
                    // rejectTask(id., taskUserid);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ComplitedTaskVerification(
                              id: id,
                              taskUserId: taskUserid,
                            )));
                  },
                  icon: Icon(
                    Icons.verified_rounded,
                    color: Colors.green,
                    size: 30,
                  )),
            ],
          );
        });
  }

  Future<void> rejectTask(String id, String taskUserId) async {
    final response = await http.post(Uri.parse(updateuserTask), body: {
      "id": id,
      "tasksid": taskUserId,
      "isTaskReject": "true",
    });
    if (response.statusCode == 200) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Homescreen()));
    }
  }

  Future<Tasksuser> _future() async {
    final pers = await SharedPreferences.getInstance();
    var userId = pers.getString(Shareper.userid);
    print(userId);

    Tasksuser taskuser;
    final response = await http.post(Uri.parse(getUsertask), body: {
      "id": userId.toString(),
      "taskstatus": "false",
      "isTaskReject": "false"
    });
    var decodedata = jsonDecode(response.body);
    // print(response.body);

    taskuser = Tasksuser.fromJson(decodedata);
    return taskuser;
  }
}
