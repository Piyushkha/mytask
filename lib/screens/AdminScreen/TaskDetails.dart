import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class TaskDetailsView extends StatefulWidget {
  String? taskName;
  String? taskDec;
  String? tasformula;
  String? taskstartDate;
  String? taskEndDate;
  String? taskExampleImage;
  // String?
  TaskDetailsView(
      {Key? key,
      this.taskName,
      this.taskDec,
      this.tasformula,
      this.taskEndDate,
      this.taskExampleImage,
      this.taskstartDate})
      : super(key: key);

  @override
  State<TaskDetailsView> createState() => _TaskDetailsViewState();
}

class _TaskDetailsViewState extends State<TaskDetailsView> {
  @override
  Widget build(BuildContext context) {
    print(widget.taskExampleImage);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.taskName.toString()),
      ),
      body: ListView(
        children: [
          Container(
            height: 200,
            child: CachedNetworkImage(
              imageUrl: widget.taskExampleImage.toString(),
              progressIndicatorBuilder: (context, url, downloadProgress) {
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        Text(downloadProgress.toString())
                      ],
                    ));
              },
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15, left: 10, right: 10),
            child: Text(widget.taskDec.toString()),
          )
        ],
      ),
    );
  }
}
