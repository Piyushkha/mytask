import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:intl/intl.dart';
import 'package:mytask/screens/MainScreen/TaskDetailsViews.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/LocalData_pers.dart';
import '../../helper/TextStyle.dart';
import 'package:http/http.dart' as http;
import '../../helper/Urls.dart';
import '../../models/UserTasks.dart';
import 'HomeScreen.dart';
import 'TaskComplitedScreen.dart';

class Rejecttask extends StatefulWidget {
  Rejecttask({Key? key}) : super(key: key);

  @override
  State<Rejecttask> createState() => _RejectTasksusertate();
}

class _RejectTasksusertate extends State<Rejecttask> {
  late Future<Tasksuser> _taskUser;
  @override
  void initState() {
    _taskUser = _future();

    super.initState();
  }

  timedi(DateTime starttime, DateTime endtime) {
    final birthday = starttime;
    final date2 = endtime;
    final difference = date2.difference(birthday).inDays;
    print(difference);
    return difference;
  }

  int indexs = 0;
  int itemCount = 0;

  @override
  Widget build(BuildContext context) {
    // timedi();
    return Scaffold(
        // appBar: AppBar(
        //   title: Text("My Reject Task's"),
        // ),
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
              return Center(child: Text("Reject Task Not Found"));
            } else if (snapshot.hasData) {
              return ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.users.length,
                  itemBuilder: (BuildContext context, int index) {
                    indexs = index + 1;
                    var snapdata = snapshot.data!.users[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (contet) => TaskDetailsViews(
                                  imageUrl: snapdata.taskExampleImage,
                                  daysLeft: 'time.toString()',
                                  taksFormula: snapdata.formula,
                                  taskDec: snapdata.taskDec,
                                  taskendDate: snapdata.taskEndDate.toString(),
                                  taskname: snapdata.taskName,
                                  taskstartDate:
                                      snapdata.taskStartDate.toString(),
                                )));
                      },
                      child: Container(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      snapdata.taskName,
                                      style: AddFriendsStyle.NameStyle,
                                    ),
                                    // SizedBox(width: 30),
                                    SizedBox(height: 6),

                                    Text(
                                        ' Task End On ${DateFormat('MMM dd, yyyy, HH-mm').format(snapdata.taskEndDate).toString()}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              // height: 20,
                              child: Text(
                                DateFormat.yMMMd()
                                    .format(snapdata
                                        .taskAssignUsername[0].taskComplitTime)
                                    .toString(),
                                // overflow: TextOverflow.visible,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            )
                          ],
                        ),
                      ),
                    );
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
            content: Column(
              children: [
                Container(
                  height: 100,
                  width: 200,
                  color: Colors.black,
                )
              ],
            ),
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
    final response = await http.post(Uri.parse(updateuserTask),
        body: {"id": id, "tasksid": taskUserId, "isTaskReject": "true"});
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
      "isTaskReject": "true"
    });
    var decodedata = jsonDecode(response.body);
    // print(response.body);

    taskuser = Tasksuser.fromJson(decodedata);
    return taskuser;
  }
}
