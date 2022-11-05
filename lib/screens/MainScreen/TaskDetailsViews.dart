import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../helper/TextStyle.dart';

class TaskDetailsViews extends StatefulWidget {
  String imageUrl;
  String taskname;
  String taskDec;
  String taskstartDate;
  String taskendDate;
  String daysLeft;
  String taksFormula;

  TaskDetailsViews(
      {Key? key,
      required this.imageUrl,
      required this.daysLeft,
      required this.taksFormula,
      required this.taskDec,
      required this.taskendDate,
      required this.taskname,
      required this.taskstartDate})
      : super(key: key);

  @override
  State<TaskDetailsViews> createState() => _TaskDetailsViewsState();
}

class _TaskDetailsViewsState extends State<TaskDetailsViews> {
  int itemCount = 0;

  File? imageTemporary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Task View"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 1000));
          setState(() {
            itemCount = itemCount + 1;
          });
        },
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          children: [
            Container(
              height: 200,
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                progressIndicatorBuilder: (context, url, downloadProgress) {
                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                        ],
                      ));
                },
                errorWidget: (context, url, error) =>
                    Image(image: AssetImage("assets/icon/imageBg.png")),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Task Name  :  ${widget.taskname}',
                style: AddFriendsStyle.NameStyle,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Task Discription  :  ${widget.taskDec}',
                style: AddFriendsStyle.NameStyle,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Task Formula  :  ${widget.taksFormula}.',
                style: AddFriendsStyle.NameStyle,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Days Left  :  ${widget.daysLeft}',
                style: AddFriendsStyle.NameStyle,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Task Start Date  :  ${widget.taskstartDate.substring(0, 10)}.',
                style: AddFriendsStyle.NameStyle,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Task End Date  :  ${widget.taskendDate.substring(0, 10)}.',
                style: AddFriendsStyle.NameStyle,
              ),
            )
          ],
        ),
      ),
    );
  }
}
