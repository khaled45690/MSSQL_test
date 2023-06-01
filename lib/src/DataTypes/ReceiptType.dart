// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:convert';

class ReceiptType {
  int receiptTypeNumber;
  String receiptTypeName;

   ReceiptType({
    required this.receiptTypeNumber,
    required this.receiptTypeName,
  });

  factory ReceiptType.fromJson(Map json) {
    return ReceiptType(
      receiptTypeNumber: json['receiptTypeNumber'],
      receiptTypeName: json['receiptTypeName'],
    );
  }

  Map toJson() {
    return {
      "receiptTypeNumber": receiptTypeNumber,
      "receiptTypeName": receiptTypeName,
    };
  }

  String toJsonString() {
    return jsonEncode({
      "receiptTypeNumber": receiptTypeNumber,
      "receiptTypeName": receiptTypeName,
    });
  }

  String toPrintableString() {
    return "{"
        "receiptTypeNumber: $receiptTypeNumber,"
        " receiptTypeName: $receiptTypeName,"
        "}";
  }

  static List<ReceiptType> fromJsonStringListToReceiptTypeList(
      String ListOfJsonString) {
    List listOfJson = jsonDecode(ListOfJsonString);
    List<ReceiptType> listOfUsers = [];
    for (var element in listOfJson) {
      listOfUsers.add(ReceiptType.fromJson(element));
    }
    return listOfUsers;
  }

  static fromReceiptTypeListToJsonList(List<ReceiptType> ListOfUsers) {
    List listOfUsers = [];

    for (var element in ListOfUsers) {
      listOfUsers.add(element.toJson());
    }
    return listOfUsers;
  }

  static fromReceiptTypeListToJsonListString(List<ReceiptType> ListOfUsers) {
    List listOfUsers = [];

    for (var element in ListOfUsers) {
      listOfUsers.add(element.toJson());
    }
    return jsonEncode(listOfUsers);
  }

  static String fromReceiptTypeListtoPrintableString(
      List<ReceiptType> ListOfUsers) {
    String listOfUsers = "[";
    for (ReceiptType element in ListOfUsers) {
      listOfUsers += "${element.toPrintableString()},";
    }
    listOfUsers += "]";
    return listOfUsers;
  }
}
