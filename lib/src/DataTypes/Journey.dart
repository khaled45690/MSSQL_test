// ignore_for_file: non_constant_identifier_names, file_names
import 'dart:convert';

import 'Receipt.dart';

class Journey {
  int F_Id;
  String F_Sdate;
  String F_Stime;
  int F_Emp_Id;
  String? F_Edate;
  String? F_Etime;
  bool isFinished;
  List<Receipt> receiptList;
  Journey({
    required this.F_Id,
    required this.F_Sdate,
    required this.F_Stime,
    required this.F_Emp_Id,
    this.F_Edate,
    this.F_Etime,
    required this.isFinished,
    required this.receiptList,
  });

  factory Journey.fromJson(Map json) {
    return Journey(
      F_Id: json['F_Id'],
      F_Sdate: json['F_Sdate'],
      F_Stime: json['F_Stime'],
      F_Emp_Id: json['F_Emp_Id'],
      F_Edate: json['F_Edate'],
      F_Etime: json['F_Etime'],
      isFinished: json['F_Edate'] == null ? false : true,
      receiptList: json['receiptList'] == null
          ? []
          : Receipt.fromJsonListToReceiptList(json['receiptList']),
    );
  }

  Map toJson() {
    return {
      "F_Id": F_Id,
      "F_Sdate": F_Sdate,
      "F_Stime": F_Stime,
      "F_Emp_Id": F_Emp_Id,
      "F_Edate": F_Edate,
      "F_Etime": F_Etime,
      "receiptList": Receipt.fromReceiptListToJsonList(receiptList),
    };
  }

  String toJsonString() {
    return jsonEncode({
      "F_Id": F_Id,
      "F_Sdate": F_Sdate,
      "F_Stime": F_Stime,
      "F_Emp_Id": F_Emp_Id,
      "F_Edate": F_Edate,
      "F_Etime": F_Etime,
      "receiptList": Receipt.fromReceiptListToJsonList(receiptList),
    });
  }

  String toPrintableString() {
    return "{"
        "F_Id: $F_Id,"
        " F_Sdate: $F_Sdate,"
        " F_Stime: $F_Stime,"
        " F_Emp_Id: $F_Emp_Id,"
        " F_Edate: $F_Edate,"
        " F_Etime: $F_Etime"
        " isFinished: $isFinished"
        " receiptList: ${Receipt.fromReceiptListtoPrintableString(receiptList)}"
        "}";
  }

  static List<Journey> fromJsonStringListToJourneyList(
      String ListOfJsonString) {
    List listOfJson = jsonDecode(ListOfJsonString);
    List<Journey> listOfUsers = [];

    for (var element in listOfJson) {
      listOfUsers.add(Journey.fromJson(element));
    }
    return listOfUsers;
  }

  static fromJourneyListToJsonList(List<Journey> ListOfUsers) {
    List listOfUsers = [];

    for (var element in ListOfUsers) {
      listOfUsers.add(element.toJson());
    }
    return listOfUsers;
  }

  static fromJourneyListToJsonListString(List<Journey> ListOfUsers) {
    List listOfUsers = [];

    for (var element in ListOfUsers) {
      listOfUsers.add(element.toJson());
    }
    return jsonEncode(listOfUsers);
  }

  static String fromJouernyListtoPrintableString(List<Journey> ListOfUsers) {
    String listOfUsers = "[";
    for (Journey element in ListOfUsers) {
      listOfUsers += "${element.toPrintableString()},";
    }
    listOfUsers += "]";
    return listOfUsers;
  }
}
