//ReceiptInternalReceiveData


// ignore_for_file: non_constant_identifier_names, file_names

import 'dart:convert';

import 'package:sql_test/src/DataTypes/CrewMember.dart';

import '../../../../../../DataTypes/ReceiptDeliver.dart';


class ReceiptInternalReceiveData {
  int F_Id_R;
  int? F_Recipt_No;
  String? F_Paper_No;
  String? F_Arrival_Time_R;
  String? F_Leaving_Time_R;
  String? Date_Edit;
  String? Time_Edit;
  String? Userid_Edit_ID;
  List<CrewMember> CrewIdList;
  List<ReceiptDeliver> deliverReceipts; // collection of F_Paper_No numbers

  ReceiptInternalReceiveData(
      {required this.F_Id_R,
      required this.F_Recipt_No,
      required this.F_Paper_No,
      this.F_Arrival_Time_R,
      this.F_Leaving_Time_R,
      this.Date_Edit,
      this.Time_Edit,
      this.Userid_Edit_ID,
      required this.deliverReceipts, // collection of F_Paper_No numbers
      required this.CrewIdList});

  factory ReceiptInternalReceiveData.fromJson(Map json) {
    return ReceiptInternalReceiveData(
      F_Id_R: json['F_Id'] ?? 0,
      F_Recipt_No: json['F_Recipt_No'] ?? 0,
      F_Paper_No: json['F_Paper_No'],
      F_Arrival_Time_R: json['F_Arrival_Time_R'],
      F_Leaving_Time_R: json['F_Leaving_Time_R'],
      Date_Edit: json['Date_Edit'],
      Time_Edit: json['Time_Edit'],
      Userid_Edit_ID: json['Userid_Edit_ID'],
      deliverReceipts: json['deliverReceipts'] ?? [],
      CrewIdList: json['CrewIdList'] == null
          ? []
          : CrewMember.fromJsonListToCrewMemberList(json['CrewIdList']),
    );
  }

  Map toJson() {
    return {
      "F_Recipt_No": F_Recipt_No,
      "F_Paper_No": F_Paper_No,
      "F_Arrival_Time_R": F_Arrival_Time_R,
      "F_Leaving_Time_R": F_Leaving_Time_R,
      "Date_Edit": Date_Edit,
      "Time_Edit": Time_Edit,
      "Userid_Edit_ID": Userid_Edit_ID,
      "deliverReceipts": deliverReceipts,
      "CrewIdList": CrewMember.fromCrewMemberListToJsonList(CrewIdList),
    };
  }

  String toJsonString() {
    return jsonEncode({
      "F_Recipt_No": F_Recipt_No,
      "F_Paper_No": F_Paper_No,
      "F_Arrival_Time_R": F_Arrival_Time_R,
      "F_Leaving_Time_R": F_Leaving_Time_R,
      "Date_Edit": Date_Edit,
      "Time_Edit": Time_Edit,
      "Userid_Edit_ID": Userid_Edit_ID,
      "deliverReceipts": deliverReceipts,
      "CrewIdList": CrewMember.fromCrewMemberListToJsonList(CrewIdList),
    });
  }

  String toPrintableString() {
    // image data will not be printed as it will take huge amount of space
    return "{"
        "F_Recipt_No: $F_Recipt_No,"
        " F_Paper_No: $F_Paper_No,"
        " F_Arrival_Time_R: $F_Arrival_Time_R,"
        " F_Leaving_Time_R: $F_Leaving_Time_R,"
        " Date_Edit: $Date_Edit,"
        " Time_Edit: $Time_Edit,"
        " Userid_Edit_ID: $Userid_Edit_ID,"
        " deliverReceipts: $deliverReceipts,"
        " CrewIdList: ${CrewMember.fromCrewMemberListToJsonList(CrewIdList)},"
        "}";
  }

  static List<ReceiptInternalReceiveData> fromJsonStringListToReceiptDeliverDataList(
      String ListOfJsonString) {
    List listOfJson = jsonDecode(ListOfJsonString);
    List<ReceiptInternalReceiveData> listOfUsers = [];

    for (var element in listOfJson) {
      listOfUsers.add(ReceiptInternalReceiveData.fromJson(element));
    }
    return listOfUsers;
  }

  static fromReceiptDeliverDataListToJsonList(
      List<ReceiptInternalReceiveData> ListOfReceiptDeliverData) {
    List listOfUsers = [];

    for (var element in ListOfReceiptDeliverData) {
      listOfUsers.add(element.toJson());
    }
    return listOfUsers;
  }

  static fromReceiptDeliverDataListToJsonListString(
      List<ReceiptInternalReceiveData> ListOfReceiptDeliverData) {
    List listOfReceiptDeliverData = [];

    for (var element in ListOfReceiptDeliverData) {
      listOfReceiptDeliverData.add(element.toJson());
    }
    return jsonEncode(listOfReceiptDeliverData);
  }

  static String fromReceiptDeliverDataListtoPrintableString(
      List<ReceiptInternalReceiveData> ListOfReceiptDeliverData) {
    String listOfReceiptDeliverData = "[";
    for (ReceiptInternalReceiveData element in ListOfReceiptDeliverData) {
      listOfReceiptDeliverData += "${element.toPrintableString()},";
    }
    listOfReceiptDeliverData += "]";
    return listOfReceiptDeliverData;
  }
}
