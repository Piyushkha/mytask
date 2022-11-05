import 'dart:convert';

AddUserstasks addUserstasksFromJson(String str) =>
    AddUserstasks.fromJson(json.decode(str));

String addUserstasksToJson(AddUserstasks data) => json.encode(data.toJson());

class AddUserstasks {
  AddUserstasks({
    required this.status,
    required this.users,
  });

  int status;
  List<User> users;

  factory AddUserstasks.fromJson(Map<String, dynamic> json) => AddUserstasks(
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
    required this.username,
    required this.email,
    required this.password,
    required this.bio,
    required this.isadmin,
    required this.active,
    required this.toBeLogOut,
    required this.toBeLogin,
    required this.isTermAccept,
    required this.profileView,
    required this.profileLike,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  String id;
  String username;
  String email;
  String password;
  String bio;
  bool isadmin;
  bool active;
  bool toBeLogOut;
  bool toBeLogin;
  bool isTermAccept;
  int profileView;
  List<dynamic> profileLike;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
        bio: json["Bio"],
        isadmin: json["isadmin"],
        active: json["active"],
        toBeLogOut: json["toBeLogOut"],
        toBeLogin: json["toBeLogin"],
        isTermAccept: json["isTermAccept"],
        profileView: json["profileView"],
        profileLike: List<dynamic>.from(json["profileLike"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "email": email,
        "password": password,
        "Bio": bio,
        "isadmin": isadmin,
        "active": active,
        "toBeLogOut": toBeLogOut,
        "toBeLogin": toBeLogin,
        "isTermAccept": isTermAccept,
        "profileView": profileView,
        "profileLike": List<dynamic>.from(profileLike.map((x) => x)),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}
