import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mytask/helper/Urls.dart';
import 'package:mytask/models/AdminTasks.dart';
import 'package:http/http.dart' as http;
import 'package:mytask/screens/AdminScreen/AddTask.dart';
import 'package:mytask/screens/AdminScreen/TaskDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../AuthScreen/Authscreen.dart';

class AdminScreen extends StatefulWidget {
  AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  late Future<Tasks> _lists;

  @override
  void initState() {
    _future();
    _lists = _future();
    super.initState();
  }

  int indexs = 0;
  int itemCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Task"),
        actions: [
          IconButton(
              onPressed: () async {
                final pers = await SharedPreferences.getInstance();
                pers.clear();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => AuthScreen()));
              },
              icon: Icon(Icons.logout))
        ],
      ),
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
        child: FutureBuilder<Tasks>(
            future: _future(),
            builder: (context, snapshot) {
              if (snapshot.data?.tasks == null) {
                return Center(
                    child: Text(
                  "No Data found",
                  style: TextStyle(color: Colors.black),
                ));
              } else if (snapshot.hasData) {
                return ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: snapshot.data!.tasks.length,
                  itemBuilder: (BuildContext context, int index) {
                    indexs = index + 1;
                    var snapdata = snapshot.data!.tasks[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TaskDetailsView(
                                  taskName: snapdata.taskName,
                                  taskDec: snapdata.taskDec,
                                  tasformula: snapdata.formula,
                                  taskEndDate: snapdata.taskEndDate.toString(),
                                  taskExampleImage: snapdata.taskExampleImage,
                                )));
                      },
                      child: Container(
                        child: ListTile(
                            trailing: snapdata.taskAssignUsername[0].taskstatus
                                        .toString() !=
                                    "true"
                                ? Card(
                                    elevation: 5,
                                    shadowColor: Colors.black,
                                    color: Colors.blue.shade900,
                                    child: Text(
                                      "In-Review",
                                      style: TextStyle(color: Colors.white),
                                    ))
                                : Card(
                                    elevation: 5,
                                    shadowColor: Colors.black,
                                    color: Colors.green.shade900,
                                    child: Text(
                                      "Complited",
                                      style: TextStyle(color: Colors.white),
                                    )),
                            leading:
                                CircleAvatar(child: Text(indexs.toString())),
                            subtitle: Text(
                                " ${snapshot.data!.tasks[index].taskDec.toString()}   "),
                            title: Text(snapshot.data!.tasks[index].taskName
                                .toString())),
                      ),
                    );
                  },
                );
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddTask()));
        },
        child: Row(
          children: [
            Icon(Icons.add),
            Text("Add"),
          ],
        ),
      ),
    );
  }

  Future<Tasks> _future() async {
    Tasks tasks;
    final response = await http.get(Uri.parse(taskget));
    var decodedata = jsonDecode(response.body);

    tasks = Tasks.fromJson(decodedata);
    return tasks;
  }
}
