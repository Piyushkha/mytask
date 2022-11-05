import 'dart:convert';

Tasksuser tasksuserFromJson(String str) => Tasksuser.fromJson(json.decode(str));

String tasksuserToJson(Tasksuser data) => json.encode(data.toJson());

class Tasksuser {
  Tasksuser({
    required this.status,
    required this.users,
  });

  int status;
  List<User> users;

  factory Tasksuser.fromJson(Map<String, dynamic> json) => Tasksuser(
        status: json["status"],
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
      };
}

class User {
  User({
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

  factory User.fromJson(Map<String, dynamic> json) => User(
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
    required this.taskDoneProfeImage,
    required this.taskcomplitedDec,
    required this.isTaskReject,
    required this.taskComplitTime,
    required this.id,
  });

  String userName;
  String userId;
  bool taskstatus;
  String taskDoneProfeImage;
  String taskcomplitedDec;
  bool isTaskReject;
  DateTime taskComplitTime;
  String id;

  factory TaskAssignUsername.fromJson(Map<String, dynamic> json) =>
      TaskAssignUsername(
        userName: json["userName"],
        userId: json["userId"],
        taskstatus: json["taskstatus"],
        taskDoneProfeImage: json["taskDoneProfeImage"],
        taskcomplitedDec: json["taskcomplitedDec"],
        isTaskReject: json["isTaskReject"],
        taskComplitTime: json["taskComplitTime"] == null
            ? json[null]
            : DateTime.parse(json["taskComplitTime"]),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "userId": userId,
        "taskstatus": taskstatus,
        "taskDoneProfeImage": taskDoneProfeImage,
        "taskcomplitedDec": taskcomplitedDec,
        "isTaskReject": isTaskReject,
        "taskComplitTime":
            taskComplitTime == null ? null : taskComplitTime.toIso8601String(),
        "_id": id,
      };
}
