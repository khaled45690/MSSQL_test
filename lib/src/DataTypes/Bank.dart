// ignore_for_file: non_constant_identifier_names, file_names

import 'dart:convert';

class Bank {
  int F_Bank_ID;
  String F_Bank_Name;

  Bank({
    required this.F_Bank_ID,
    required this.F_Bank_Name,
  });

  factory Bank.fromJson(Map json) {
    return Bank(
      F_Bank_ID: json['F_Bank_ID'],
      F_Bank_Name: json['F_Bank_Name'],
    );
  }

  Map toJson() {
    return {
      "F_Bank_ID": F_Bank_ID,
      "F_Bank_Name": F_Bank_Name,
    };
  }

  String toJsonString() {
    return jsonEncode({
      "F_Bank_ID": F_Bank_ID,
      "F_Bank_Name": F_Bank_Name,
    });
  }

  @override
  String toString() {
    return "{"
        "F_Bank_ID: $F_Bank_ID,"
        " F_Bank_Name: $F_Bank_Name,"
        "}";
  }

  static List<Bank> fromJsonStringListToBankList(
      String ListOfJsonString) {
    List listOfJson = jsonDecode(ListOfJsonString);
    List<Bank> listOfUsers = [];

    for (var element in listOfJson) {
      listOfUsers.add(Bank.fromJson(element));
    }
    return listOfUsers;
  }

  static fromBankListToJsonList(List<Bank> ListOfBank) {
    List listOfUsers = [];

    for (var element in ListOfBank) {
      listOfUsers.add(element.toJson());
    }
    return listOfUsers;
  }

  static fromBankListToJsonListString(List<Bank> ListOfBank) {
    List listOfBank = [];

    for (var element in ListOfBank) {
      listOfBank.add(element.toJson());
    }
    return jsonEncode(listOfBank);
  }

  static String fromBankListtoPrintableString(
      List<Bank> ListOfBank) {
    String listOfBank = "[";
    for (Bank element in ListOfBank) {
      listOfBank += "${element.toString()},";
    }
    listOfBank += "]";
    return listOfBank;
  }
}
