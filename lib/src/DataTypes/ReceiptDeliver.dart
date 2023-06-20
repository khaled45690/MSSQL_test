// ignore_for_file: file_names

import 'dart:convert';

import 'Receipt.dart';

class ReceiptDeliver {
  // ignore_for_file: non_constant_identifier_names

  int F_Recipt_No;
  String F_Paper_No; // collection of F_Paper_No numbers

  ReceiptDeliver({
    required this.F_Recipt_No,
    required this.F_Paper_No,
  });

  factory ReceiptDeliver.fromJson(Map json) {
    return ReceiptDeliver(
      F_Recipt_No: json['F_Recipt_No'],
      F_Paper_No: json['F_Paper_No'].toString(),
    );
  }

  Map toJson() {
    return {
      "F_Recipt_No": F_Recipt_No,
      "F_Paper_No": F_Paper_No,
    };
  }

  String toJsonString() {
    return jsonEncode({
      "F_Recipt_No": F_Recipt_No,
      "F_Paper_No": F_Paper_No,
    });
  }

  String toPrintableString() {
    return "{"
        "F_Recipt_No: $F_Recipt_No,"
        " F_Paper_No: $F_Paper_No,"
        "}";
  }

  static List<ReceiptDeliver> fromJsonStringListToReceiptDeliverList(String ListOfJsonString) {
    List listOfJson = jsonDecode(ListOfJsonString);
    List<ReceiptDeliver> listOfUsers = [];

    for (var element in listOfJson) {
      listOfUsers.add(ReceiptDeliver.fromJson(element));
    }
    return listOfUsers;
  }

  static fromReceiptDeliverListToJsonList(List<ReceiptDeliver> ListOfReceiptDeliver) {
    List listOfUsers = [];

    for (var element in ListOfReceiptDeliver) {
      listOfUsers.add(element.toJson());
    }
    return listOfUsers;
  }

  static fromReceiptDeliverListToJsonListString(List<ReceiptDeliver> ListOfReceiptDeliver) {
    List listOfReceiptDeliver = [];

    for (var element in ListOfReceiptDeliver) {
      listOfReceiptDeliver.add(element.toJson());
    }
    return jsonEncode(listOfReceiptDeliver);
  }

  static String fromReceiptDeliverListtoPrintableString(List<ReceiptDeliver> ListOfReceiptDeliver) {
    String listOfReceiptDeliver = "[";
    for (ReceiptDeliver element in ListOfReceiptDeliver) {
      listOfReceiptDeliver += "${element.toPrintableString()},";
    }
    listOfReceiptDeliver += "]";
    return listOfReceiptDeliver;
  }

  static List<ReceiptDeliver> fromReceiptListToReceiptDeliverList(List<Receipt> ListOfReceipts) {
    String receiptListJsonString = Receipt.fromReceiptListToJsonListString(ListOfReceipts);
    return ReceiptDeliver.fromJsonStringListToReceiptDeliverList(receiptListJsonString);
  }

   static ReceiptDeliver fromReceiptToReceiptDeliver(Receipt receipt) {
    Map receiptString = receipt.toJson();
    return ReceiptDeliver.fromJson(receiptString);
  }
}
