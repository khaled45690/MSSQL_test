// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:sql_test/src/DataTypes/CustomerBranch.dart';

class Customer {
  int CustID;
  String CustName;
  List<CustomerBranch> CustomerBranches = [];

  Customer({
    required this.CustID,
    required this.CustName, 
    this.CustomerBranches = const [],
  });

  factory Customer.fromJson(Map json) {
    return Customer(
      CustID: json['CustID'],
      CustName: json['CustName'],
      CustomerBranches: CustomerBranch.fromJsonListToCustomerBranchList(json['CustomerBranches'] ?? [])
    
    );
  }


  Map toJson() {
    return {
      "CustID": CustID,
      "CustName": CustName,
      "CustomerBranches":
          CustomerBranch.fromCustomerBranchListToJsonList(CustomerBranches),
    };
  }

  String toJsonString() {
    return jsonEncode({
      "CustID": CustID,
      "CustName": CustName,
      "CustomerBranches":
          CustomerBranch.fromCustomerBranchListToJsonList(CustomerBranches),
    });
  }

  String toPrintableString() {
    return "{"
        "CustID: $CustID,"
        " CustName: $CustName,"
        " CustomerBranches: ${CustomerBranch.fromCustomerBranchListToJsonList(CustomerBranches)},"
        "}";
  }

  static List<Customer> fromJsonStringListToCustomerList(
      String ListOfJsonString) {
    List listOfJson = jsonDecode(ListOfJsonString);
    List<Customer> listOfUsers = [];

    for (var element in listOfJson) {
        listOfUsers.add(Customer.fromJson(element));
    }
    return listOfUsers;
  }


    static List<Customer> fromJsonListToCustomerList(
       List listOfJson) {
    List<Customer> listOfUsers = [];

    for (var element in listOfJson) {
        listOfUsers.add(Customer.fromJson(element));
    }
    return listOfUsers;
  }

  static fromCustomerListToJsonList(List<Customer> ListOfCustomer) {
    List listOfUsers = [];

    for (var element in ListOfCustomer) {
      listOfUsers.add(element.toJson());
    }
    return listOfUsers;
  }

  static fromCustomerListToJsonListString(List<Customer> ListOfCustomer) {
    List listOfCustomer = [];

    for (var element in ListOfCustomer) {
      listOfCustomer.add(element.toJson());
    }
    return jsonEncode(listOfCustomer);
  }

  static String fromCustomerListtoPrintableString(
      List<Customer> ListOfCustomer) {
    String listOfCustomer = "[";
    for (Customer element in ListOfCustomer) {
      listOfCustomer += "${element.toPrintableString()},";
    }
    listOfCustomer += "]";
    return listOfCustomer;
  }
}
