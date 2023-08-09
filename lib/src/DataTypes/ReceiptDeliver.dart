// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sql_test/src/DataTypes/Customer.dart';
import 'package:sql_test/src/DataTypes/CustomerBranch.dart';

import '../Utilities/Prefs.dart';
import '../Utilities/Strings.dart';
import 'Receipt.dart';
import 'ReceiptDeliverDetails.dart';

class ReceiptDeliver {
  // ignore_for_file: non_constant_identifier_names

  int F_Recipt_No;
  String F_Paper_No; // collection of F_Paper_No numbers
  Customer F_Bank_Id_D;
  CustomerBranch F_Branch_Id_D;
  Customer F_Bank_Id_R;
  CustomerBranch F_Branch_Id_R;
  List<ReceiptDeliverDetails> receiptDeliverDetails;

  ReceiptDeliver({
    required this.F_Recipt_No,
    required this.F_Paper_No,
    required this.F_Bank_Id_D,
    required this.F_Branch_Id_D,
    required this.F_Bank_Id_R,
    required this.F_Branch_Id_R,
    required this.receiptDeliverDetails,
  });

  factory ReceiptDeliver.fromJson(Map json, {Map isDuplicate = const {}}) {
    Customer F_Bank_Id_D = json['F_Bank_Id_D']  == null ? Customer.fromJson(json['F_Cust']) : _setCustomer(json['F_Bank_Id_D']) ;
    Customer F_Bank_Id_R = json['F_Bank_Id_R']  == null ? Customer.fromJson(json['F_Cust_R']) : _setCustomer(json['F_Bank_Id_R']);
    CustomerBranch F_Branch_Id_D =  json['F_Branch_Id_D']  == null ? CustomerBranch.fromJson(json['F_Branch_D']) : _setBranch(F_Bank_Id_D.CustomerBranches, json['F_Branch_Id_D']);
    CustomerBranch F_Branch_Id_R = json['F_Branch_Id_R']  == null ? CustomerBranch.fromJson(json['F_Branch_R']) : _setBranch(F_Bank_Id_R.CustomerBranches, json['F_Branch_Id_R']);
    List<ReceiptDeliverDetails> receiptDeliverDetails = _setReceiptDeliverDetails(json, isDuplicate);
    return ReceiptDeliver(
      F_Recipt_No: json['F_Recipt_No'],
      F_Paper_No: json['F_Paper_No'].toString(),
      F_Bank_Id_D: F_Bank_Id_D,
      F_Branch_Id_D: F_Branch_Id_D,
      F_Bank_Id_R: F_Bank_Id_R,
      F_Branch_Id_R: F_Branch_Id_R,
      receiptDeliverDetails: receiptDeliverDetails,
    );
  }

  Map toJson() {
    return {
      "F_Recipt_No": F_Recipt_No,
      "F_Paper_No": F_Paper_No,
      "F_Bank_Id_D": F_Bank_Id_D.toJson(),
      "F_Branch_Id_D": F_Branch_Id_D.toJson(),
      "F_Bank_Id_R": F_Bank_Id_R.toJson(),
      "F_Branch_Id_R": F_Branch_Id_R.toJson(),
      "receiptDeliverDetails": ReceiptDeliverDetails.fromReceiptDeliverDetailsListToJsonList(receiptDeliverDetails),
    };
  }

  String toJsonString() {
    return jsonEncode({
      "F_Recipt_No": F_Recipt_No,
      "F_Paper_No": F_Paper_No,
      "F_Bank_Id_D": F_Bank_Id_D.toJson(),
      "F_Branch_Id_D": F_Branch_Id_D.toJson(),
      "F_Bank_Id_R": F_Bank_Id_R.toJson(),
      "F_Branch_Id_R": F_Branch_Id_R.toJson(),
      "receiptDeliverDetails": ReceiptDeliverDetails.fromReceiptDeliverDetailsListToJsonList(receiptDeliverDetails),
    });
  }

  String toPrintableString() {
    return "{"
        "F_Recipt_No: $F_Recipt_No,"
        "F_Paper_No: $F_Paper_No,"
        "F_Bank_Id_D: ${F_Bank_Id_D.toPrintableString()},"
        "F_Branch_Id_D: ${F_Branch_Id_D.toPrintableString()},"
        "F_Bank_Id_R: ${F_Bank_Id_R.toPrintableString()},"
        "F_Branch_Id_R: ${F_Branch_Id_R.toPrintableString()},"
        "receiptDeliverDetails: ${ReceiptDeliverDetails.fromReceiptDeliverDetailsListToJsonListString(receiptDeliverDetails)},"
        "}";
  }

  static List<ReceiptDeliver> fromJsonStringListToReceiptDeliverList(String ListOfJsonString) {
    List listOfJson = jsonDecode(ListOfJsonString);
    List<ReceiptDeliver> listOfUsers = [];
    Map isDuplicate = {};
    int i = 0;
    for (var element in listOfJson) {
      if (isDuplicate[element["F_Recipt_No"]] != null) {
        listOfUsers[isDuplicate[element["F_Recipt_No"]]].receiptDeliverDetails.add(ReceiptDeliverDetails.fromJson(element));
      } else {
        isDuplicate[element["F_Recipt_No"]] = i;
        listOfUsers.add(ReceiptDeliver.fromJson(element));
        i++;
      }
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
    print("receipt.toJson()");
    debugPrint(receipt.toPrintableString() , wrapWidth: 300);
    Map receiptString = receipt.toJson();
    return ReceiptDeliver.fromJson(receiptString);
  }

  static Customer _setCustomer(int customerID) {
    String? customers = Prefs.getString(customersInfo);
    if (customers == null) return Customer(CustID: 0, CustName: updateData, CustomerBranches: []);
    List<Customer> customerList = Customer.fromJsonStringListToCustomerList(customers);
    Customer? selectedCustomer;
    for (Customer customer in customerList) {
      if (customer.CustID == customerID) selectedCustomer = customer;
    }
    return selectedCustomer ?? Customer(CustID: 0, CustName: updateData, CustomerBranches: []);
  }

  static CustomerBranch _setBranch(List<CustomerBranch> customerBranches, int branchId) {
    CustomerBranch? selectedBranch;
    for (CustomerBranch customerBranche in customerBranches) {
      if (customerBranche.F_Branch_Id == branchId) selectedBranch = customerBranche;
    }
    return selectedBranch ?? CustomerBranch(F_Branch_Id: 1, F_Cust_Id: 1, F_Branch_Internal: 1, F_Branch_Name: updateData);
  }

  static List<ReceiptDeliverDetails> _setReceiptDeliverDetails(Map json, Map isDuplicate) {
    if (json["ReceiptDetailsList"] != null) return ReceiptDeliverDetails.fromJsonStringListToReceiptDeliverDetailsList(jsonEncode(json["ReceiptDetailsList"]));
    return [ReceiptDeliverDetails.fromJson(json)];
  }
}
