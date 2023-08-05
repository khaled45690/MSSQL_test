// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:convert';

import 'package:sql_test/src/DataTypes/Currency.dart';
import '../Utilities/Prefs.dart';
import '../Utilities/Strings.dart';
import 'Receipt.dart';

class ReceiptDeliverDetails {

  Currency currency;
  double F_Total_val;
  String? F_Banknote_Class;
  int F_Bags_No;

  ReceiptDeliverDetails({
    required this.currency,
    required this.F_Total_val,
    required this.F_Bags_No,
    this.F_Banknote_Class,
  });

  factory ReceiptDeliverDetails.fromJson(Map json) {
    return ReceiptDeliverDetails(
      currency: _setCurrency(json['F_Currency_Id']),
      F_Total_val: json['F_Total_val'],
      F_Bags_No: json['F_Bags_No'],
      F_Banknote_Class: json['F_Banknote_Class'],
    );
  }

  Map toJson() {
    return {
      "currency": currency.toJson(),
      "F_Total_val": F_Total_val,
      "F_Bags_No": F_Bags_No,
      "F_Banknote_Class": F_Banknote_Class,
    };
  }

  String toJsonString() {
    return jsonEncode({
      "currency": currency.toJson(),
      "F_Total_val": F_Total_val,
      "F_Bags_No": F_Bags_No,
      "F_Banknote_Class": F_Banknote_Class,
    });
  }

  String toPrintableString() {
    return "{"
        "F_Recipt_No: ${currency.toJson()},"
        " F_Paper_No: $F_Total_val,"
        " F_Bags_No: $F_Bags_No,"
        "F_Banknote_Class: $F_Banknote_Class,"
        "}";
  }

  static List<ReceiptDeliverDetails> fromJsonStringListToReceiptDeliverDetailsList(String ListOfJsonString) {
    List listOfJson = jsonDecode(ListOfJsonString);
    List<ReceiptDeliverDetails> listOfUsers = [];

    for (var element in listOfJson) {
      listOfUsers.add(ReceiptDeliverDetails.fromJson(element));
    }
    return listOfUsers;
  }

  static fromReceiptDeliverDetailsListToJsonList(List<ReceiptDeliverDetails> ListOfReceiptDeliverDetails) {
    List listOfUsers = [];

    for (var element in ListOfReceiptDeliverDetails) {
      listOfUsers.add(element.toJson());
    }
    return listOfUsers;
  }

  static fromReceiptDeliverDetailsListToJsonListString(List<ReceiptDeliverDetails> ListOfReceiptDeliverDetails) {
    List listOfReceiptDeliverDetails = [];

    for (var element in ListOfReceiptDeliverDetails) {
      listOfReceiptDeliverDetails.add(element.toJson());
    }
    return jsonEncode(listOfReceiptDeliverDetails);
  }

  static String fromReceiptDeliverDetailsListtoPrintableString(List<ReceiptDeliverDetails> ListOfReceiptDeliverDetails) {
    String listOfReceiptDeliverDetails = "[";
    for (ReceiptDeliverDetails element in ListOfReceiptDeliverDetails) {
      listOfReceiptDeliverDetails += "${element.toPrintableString()},";
    }
    listOfReceiptDeliverDetails += "]";
    return listOfReceiptDeliverDetails;
  }

  static List<ReceiptDeliverDetails> fromReceiptListToReceiptDeliverDetailsList(List<Receipt> ListOfReceipts) {
    String receiptListJsonString = Receipt.fromReceiptListToJsonListString(ListOfReceipts);
    return ReceiptDeliverDetails.fromJsonStringListToReceiptDeliverDetailsList(receiptListJsonString);
  }

  static ReceiptDeliverDetails fromReceiptToReceiptDeliverDetails(Receipt receipt) {
    Map receiptString = receipt.toJson();
    return ReceiptDeliverDetails.fromJson(receiptString);
  }

  static Currency _setCurrency(int currencyID) {
    String? currencyData = Prefs.getString(currencyInfo);
    if (currencyData == null) return Currency(F_CURRANCY_ID: 1, F_CURRANCY_NAM: updateData);
    List<Currency> currencyList = Currency.fromJsonStringListToCurrencyList(currencyData);
    Currency? selectedCurrency;
    for (var currency in currencyList) {
      if (currency.F_CURRANCY_ID == currencyID) selectedCurrency = currency;
    }
    return selectedCurrency ?? Currency(F_CURRANCY_ID: 1, F_CURRANCY_NAM: updateData);
  }
}
