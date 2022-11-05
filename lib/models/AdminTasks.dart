import 'dart:convert';

Tasks tasksFromJson(String str) => Tasks.fromJson(json.decode(str));

String tasksToJson(Tasks data) => json.encode(data.toJson());

class Tasks {
  Tasks({
    required this.tasks,
  });

  List<Task> tasks;

  factory Tasks.fromJson(Map<String, dynamic> json) => Tasks(
        tasks: List<Task>.from(json["tasks"].map((x) => Task.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "tasks": List<dynamic>.from(tasks.map((x) => x.toJson())),
      };
}

class Task {
  Task({
    required this.id,
    required this.taskName,
    required this.taskDec,
    required this.formula,
    required this.taskStartDate,
    required this.taskEndDate,
    required this.taskExampleImage,
    required this.taskAssignUsername,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  String id;
  String taskName;
  String taskDec;
  String formula;
  DateTime taskStartDate;
  DateTime taskEndDate;
  String taskExampleImage;
  List<TaskAssignUsername> taskAssignUsername;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["_id"],
        taskName: json["taskName"],
        taskDec: json["taskDec"],
        formula: json["formula"],
        taskStartDate: DateTime.parse(json["taskStartDate"]),
        taskEndDate: DateTime.parse(json["taskEndDate"]),
        taskExampleImage: json["taskExampleImage"],
        taskAssignUsername: List<TaskAssignUsername>.from(
            json["taskAssignUsername"]
                .map((x) => TaskAssignUsername.fromJson(x))),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "taskName": taskName,
        "taskDec": taskDec,
        "formula": formula,
        "taskStartDate": taskStartDate.toIso8601String(),
        "taskEndDate": taskEndDate.toIso8601String(),
        "taskExampleImage": taskExampleImage,
        "taskAssignUsername":
            List<dynamic>.from(taskAssignUsername.map((x) => x.toJson())),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}

class TaskAssignUsername {
  TaskAssignUsername({
    required this.userName,
    required this.userId,
    required this.taskstatus,
    required this.id,
  });

  String userName;
  String userId;
  bool taskstatus;
  String id;

  factory TaskAssignUsername.fromJson(Map<String, dynamic> json) =>
      TaskAssignUsername(
        userName: json["userName"],
        userId: json["userId"],
        taskstatus: json["taskstatus"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "userId": userId,
        "taskstatus": taskstatus,
        "_id": id,
      };
}
