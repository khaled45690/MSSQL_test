// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class User {
  int F_EmpID;
  String F_EmpName;
  String F_EmpType;
  int F_Login;
  int F_Password;
  int F_EmpTypeID;
  int F_Prevlage;
  String? dateOfLogin;

  User(
      {required this.F_EmpID,
      required this.F_EmpName,
      required this.F_EmpType,
      required this.F_Login,
      required this.F_Password,
      required this.F_EmpTypeID,
      required this.F_Prevlage,
      this.dateOfLogin});

  factory User.fromJson(Map json) {
    return User(
        F_EmpID: json['F_EmpID'],
        F_EmpName: json['F_EmpName'],
        F_EmpType: json['F_EmpType'],
        F_Login: json['F_Login'],
        F_Password: json['F_Password'],
        F_EmpTypeID: json['F_EmpTypeID'],
        F_Prevlage: json['F_Prevlage'],
        dateOfLogin: json['dateOfLogin']);
  }

  Map toJson() {
    return {
      "F_EmpID": F_EmpID,
      "F_EmpName": F_EmpName,
      "F_EmpType": F_EmpType,
      "F_Login": F_Login,
      "F_Password": F_Password,
      "F_EmpTypeID": F_EmpTypeID,
      "F_Prevlage": F_Prevlage,
      "dateOfLogin": dateOfLogin,
    };
  }

  String toJsonString() {
    return jsonEncode({
      "F_EmpID": F_EmpID,
      "F_EmpName": F_EmpName,
      "F_EmpType": F_EmpType,
      "F_Login": F_Login,
      "F_Password": F_Password,
      "F_EmpTypeID": F_EmpTypeID,
      "F_Prevlage": F_Prevlage,
      "dateOfLogin": dateOfLogin,
    });
  }

  static List filterUserListData(List ListOfJson) {
    List listOfUsers = [];

    for (var json in ListOfJson) {
      Map userFiltered = {
        "F_EmpID": json['F_EmpID'],
        "F_EmpName": json['F_EmpName'],
        "F_EmpType": json['F_EmpType'],
        "F_Login": json['F_Login'],
        "F_Password": json['F_Password'],
        "F_EmpTypeID": json['F_EmpTypeID'],
        "F_Prevlage": json['F_Prevlage'],
        "dateOfLogin": json['dateOfLogin']
      };
      listOfUsers.add(userFiltered);
    }
    return listOfUsers;
  }

  static List<User> fromJsonStringListToUserList(String ListOfJsonString) {
    List listOfJson = jsonDecode(ListOfJsonString);
    List<User> listOfUsers = [];

    for (var element in listOfJson) {
      listOfUsers.add(User.fromJson(element));
    }
    return listOfUsers;
  }

  static fromUserListToJsonList(List<User> ListOfUsers) {
    List listOfUsers = [];

    for (var element in ListOfUsers) {
      listOfUsers.add(element.toJson());
    }
    return listOfUsers;
  }
}
