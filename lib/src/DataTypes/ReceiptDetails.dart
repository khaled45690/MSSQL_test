// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sql_test/src/Utilities/VariableCodes.dart';

import '../Utilities/Prefs.dart';
import '../Utilities/Strings.dart';
import 'Currency.dart';

class ReceiptDetails {
  int F_Recipt_No;
  String? F_Seal_No_From;
  String? F_Seal_No_To;
  Currency F_Currency_Id;
  int F_Pack_No; // عدد الاوراق بالباكو
  int F_Pack_Class; // فئة الورقية للباكو
  int F_BankNote_No; // عدد الاوراق بالباكو
  String? F_BankNote_Class; // فئة العملات المعدنية
  double F_Total_val; // اجمالى الاموال بالعملة المختارة
  int F_RowNo;
  int F_Currency_Type; // F_Uinte_Id نوع العملة و غالبا تتشابة مع المتغير
  int F_Uinte_Id; // F_Currency_Type نوع العملة و غالبا تتشابة مع المتغير
  double F_Convert_Factor;
  double F_EGP_Amount; // اجمالى الاموال بالعملة المحلية المصرية
  int F_Bags_No; // عدد الحقائب

  ReceiptDetails({
    required this.F_Recipt_No,
    this.F_Seal_No_From,
    this.F_Seal_No_To,
    required this.F_Currency_Id,
    required this.F_Pack_No,
    required this.F_Pack_Class,
    this.F_BankNote_Class,
    required this.F_Total_val,
    required this.F_RowNo,
    required this.F_Currency_Type,
    required this.F_Uinte_Id,
    required this.F_Convert_Factor,
    required this.F_EGP_Amount,
    required this.F_Bags_No,
    required this.F_BankNote_No,
  });

  factory ReceiptDetails.fromJson(Map json) {
    return ReceiptDetails(
      F_Recipt_No: json['F_Recipt_No'] ?? 0,
      F_Seal_No_From: json['F_Seal_No_From']?.toString(),
      F_Seal_No_To: json['F_Seal_No_To']?.toString(),
      F_Currency_Id: _currencySetter(json['F_Currency_Id']),
      F_Pack_No: json['F_Pack_No'] ?? 0,
      F_Pack_Class: json['F_Pack_Class'] ?? 0,
      F_Total_val: json['F_Total_val'] ?? 0,
      F_BankNote_Class: json['F_BankNote_Class'],
      F_RowNo: json['F_RowNo'] ?? 0,
      F_Currency_Type: json['F_Currency_Type'] ?? LocalCurrency,
      F_Uinte_Id: json['F_Uinte_Id'] ?? LocalCurrency,
      F_Convert_Factor: json['F_Convert_Factor'] ?? 0,
      F_EGP_Amount: json['F_EGP_Amount'] ?? 0,
      F_Bags_No: json['F_Bags_No'] ?? 0,
      F_BankNote_No: json['F_BankNote_No'] ?? 0,
    );
  }

  Map toJson() {
    return {
      "F_Recipt_No": F_Recipt_No,
      "F_Seal_No_From": F_Seal_No_From,
      "F_Seal_No_To": F_Seal_No_To,
      "F_Currency_Id": F_Currency_Id.toJson(),
      "F_Pack_No": F_Pack_No,
      "F_Pack_Class": F_Pack_Class,
      "F_BankNote_Class": F_BankNote_Class,
      "F_Total_val": F_Total_val,
      "F_RowNo": F_RowNo,
      "F_Currency_Type": F_Currency_Type,
      "F_Uinte_Id": F_Uinte_Id,
      "F_Convert_Factor": F_Convert_Factor,
      "F_EGP_Amount": F_EGP_Amount,
      "F_Bags_No": F_Bags_No,
      "F_BankNote_No": F_BankNote_No,
    };
  }

  String toJsonString() {
    return jsonEncode({
      "F_Recipt_No": F_Recipt_No,
      "F_Seal_No_From": F_Seal_No_From,
      "F_Seal_No_To": F_Seal_No_To,
      "F_Currency_Id": F_Currency_Id.toJson(),
      "F_Pack_No": F_Pack_No,
      "F_Pack_Class": F_Pack_Class,
      "F_BankNote_Class": F_BankNote_Class,
      "F_Total_val": F_Total_val,
      "F_RowNo": F_RowNo,
      "F_Currency_Type": F_Currency_Type,
      "F_Uinte_Id": F_Uinte_Id,
      "F_Convert_Factor": F_Convert_Factor,
      "F_EGP_Amount": F_EGP_Amount,
      "F_Bags_No": F_Bags_No,
      "F_BankNote_No": F_BankNote_No,
    });
  }

  String toPrintableString() {
    return "{"
        "F_Recipt_No: $F_Recipt_No,"
        " F_Seal_No_From: $F_Seal_No_From,"
        " F_Currency_Id: ${F_Currency_Id.toPrintableString()},"
        " F_Pack_No: $F_Pack_No,"
        " F_Pack_Class: $F_Pack_Class,"
        " F_BankNote_Class: $F_BankNote_Class,"
        " F_Total_val: $F_Total_val,"
        " F_RowNo: $F_RowNo,"
        " F_Currency_Type: $F_Currency_Type,"
        " F_Uinte_Id: $F_Uinte_Id,"
        " F_Convert_Factor: $F_Convert_Factor,"
        " F_EGP_Amount: $F_EGP_Amount,"
        " F_Bags_No: $F_Bags_No,"
        " F_BankNote_No: $F_BankNote_No,"
        "}";
  }

  static List<ReceiptDetails> fromJsonStringListToReceiptDetailsList(
      String ListOfJsonString) {
    List listOfJson = jsonDecode(ListOfJsonString);
    List<ReceiptDetails> listOfUsers = [];

    for (var element in listOfJson) {
      listOfUsers.add(ReceiptDetails.fromJson(element));
    }
    return listOfUsers;
  }

  static List<ReceiptDetails> fromJsonListToReceiptDetailsList(
      List listOfJson) {
    List<ReceiptDetails> listOfUsers = [];

    for (var element in listOfJson) {
      listOfUsers.add(ReceiptDetails.fromJson(element));
    }
    return listOfUsers;
  }

  static fromReceiptDetailsListToJsonList(
      List<ReceiptDetails> ListOfReceiptDetails) {
    List listOfUsers = [];

    for (var element in ListOfReceiptDetails) {
      listOfUsers.add(element.toJson());
    }
    return listOfUsers;
  }

  static fromReceiptDetailsListToJsonListString(
      List<ReceiptDetails> ListOfReceiptDetails) {
    List listOfReceiptDetails = [];

    for (var element in ListOfReceiptDetails) {
      listOfReceiptDetails.add(element.toJson());
    }
    return jsonEncode(listOfReceiptDetails);
  }

  static String fromReceiptDetailsListtoPrintableString(
      List<ReceiptDetails> ListOfReceiptDetails) {
    String listOfReceiptDetails = "[";
    for (ReceiptDetails element in ListOfReceiptDetails) {
      listOfReceiptDetails += "${element.toPrintableString()},";
    }
    listOfReceiptDetails += "]";
    return listOfReceiptDetails;
  }

  static Currency _currencySetter(var currencyParameter) {
    Currency returnedCurrency =
        Currency(F_CURRANCY_ID: 1, F_CURRANCY_NAM: 'جنيه مصرى');
    if (currencyParameter == null) {
      return returnedCurrency;
    } else if (currencyParameter is int) {
      String currencyData = Prefs.getString(currencyInfo)!;
      List<Currency> currencyList =
          Currency.fromJsonStringListToCurrencyList(currencyData);
      for (var currency in currencyList) {
        if (currency.F_CURRANCY_ID == currencyParameter) {
          returnedCurrency = currency;
        }
      }
      return returnedCurrency;
    } else {
      returnedCurrency = Currency.fromJson(currencyParameter);
      return returnedCurrency;
    }
  }
}
