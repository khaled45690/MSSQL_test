// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class CustomerBranch {
  int F_Branch_Id;
  int F_Cust_Id;
  int F_Branch_Internal;
  String F_Branch_Name;

  
  CustomerBranch({
    required this.F_Branch_Id,
    required this.F_Cust_Id,
    required this.F_Branch_Internal,
    required this.F_Branch_Name,
  });

 factory CustomerBranch.fromJson(Map json) {
    return CustomerBranch(
      F_Branch_Id: json['F_Branch_Id'],
      F_Cust_Id: json['F_Cust_Id'],
      F_Branch_Internal: json['F_Branch_Internal'],
      F_Branch_Name: json['F_Branch_Name'],
    );
  }

  Map toJson() {
    return {
      "F_Branch_Id": F_Branch_Id,
      "F_Cust_Id": F_Cust_Id,
      "F_Branch_Internal": F_Branch_Internal,
      "F_Branch_Name": F_Branch_Name,
    };
  }

  String toJsonString() {
    return jsonEncode({
      "F_Branch_Id": F_Branch_Id,
      "F_Cust_Id": F_Cust_Id,
      "F_Branch_Internal": F_Branch_Internal,
      "F_Branch_Name": F_Branch_Name,
    });
  }

  String toPrintableString() {
    return "{"
        "F_Branch_Id: $F_Branch_Id,"
        " F_Cust_Id: $F_Cust_Id,"
        " F_Branch_Internal: $F_Branch_Internal,"
        " F_Branch_Name: $F_Branch_Name,"
        "}";
  }
    static List<CustomerBranch> fromJsonStringListToCustomerBranchList(
      String ListOfJsonString) {
    List listOfJson = jsonDecode(ListOfJsonString);
    List<CustomerBranch> listOfUsers = [];

    for (var element in listOfJson) {
      listOfUsers.add(CustomerBranch.fromJson(element));
    }
    return listOfUsers;
  }

      static List<CustomerBranch> fromJsonListToCustomerBranchList(
      List ListOfJson) {
    List<CustomerBranch> listOfUsers = [];

    for (var element in ListOfJson) {
      listOfUsers.add(CustomerBranch.fromJson(element));
    }
    return listOfUsers;
  }

  static fromCustomerBranchListToJsonList(List<CustomerBranch> ListOfCustomerBranch) {
    List listOfUsers = [];

    for (var element in ListOfCustomerBranch) {
      listOfUsers.add(element.toJson());
    }
    return listOfUsers;
  }

  static fromCustomerBranchListToJsonListString(List<CustomerBranch> ListOfCustomerBranch) {
    List listOfCustomerBranch = [];

    for (var element in ListOfCustomerBranch) {
      listOfCustomerBranch.add(element.toJson());
    }
    return jsonEncode(listOfCustomerBranch);
  }

  static String fromCustomerBranchListtoPrintableString(List<CustomerBranch> ListOfCustomerBranch) {
    String listOfCustomerBranch = "[";
    for (CustomerBranch element in ListOfCustomerBranch) {
      listOfCustomerBranch += "${element.toPrintableString()},";
    }
    listOfCustomerBranch += "]";
    return listOfCustomerBranch;
  }
}
