// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class CompanyBranch {
  // this data type is used to represent the company's internal branches
  //if it will be stored in a companies branch

  // F_Sort_Loc_Id and F_Sort_Loc_Name are the variables used in the database that's
  // why I used the same names in order to make it easy for me in queries later on

  int F_Sort_Loc_Id;
  String F_Sort_Loc_Name;

  CompanyBranch({
    required this.F_Sort_Loc_Id,
    required this.F_Sort_Loc_Name,
  });

  factory CompanyBranch.fromJson(Map json) {
    return CompanyBranch(
      F_Sort_Loc_Id: json['F_Sort_Loc_Id'],
      F_Sort_Loc_Name: json['F_Sort_Loc_Name'],
    );
  }

  Map toJson() {
    return {
      "F_Sort_Loc_Id": F_Sort_Loc_Id,
      "F_Sort_Loc_Name": F_Sort_Loc_Name,
    };
  }

  String toJsonString() {
    return jsonEncode({
      "F_Sort_Loc_Id": F_Sort_Loc_Id,
      "F_Sort_Loc_Name": F_Sort_Loc_Name,
    });
  }

  String toPrintableString() {
    return "{"
        "F_Sort_Loc_Id: $F_Sort_Loc_Id,"
        " F_Sort_Loc_Name: $F_Sort_Loc_Name,"
        "}";
  }

  static List<CompanyBranch> fromJsonStringListToCompanyBrancheList(
      String ListOfJsonString) {
    List listOfJson = jsonDecode(ListOfJsonString);
    List<CompanyBranch> listOfUsers = [];

    for (var element in listOfJson) {
      listOfUsers.add(CompanyBranch.fromJson(element));
    }
    return listOfUsers;
  }

  static fromCompanyBrancheListToJsonList(
      List<CompanyBranch> ListOfCompanyBranche) {
    List listOfUsers = [];

    for (var element in ListOfCompanyBranche) {
      listOfUsers.add(element.toJson());
    }
    return listOfUsers;
  }

  static fromCompanyBrancheListToJsonListString(
      List<CompanyBranch> ListOfCompanyBranche) {
    List listOfCompanyBranche = [];

    for (var element in ListOfCompanyBranche) {
      listOfCompanyBranche.add(element.toJson());
    }
    return jsonEncode(listOfCompanyBranche);
  }

  static String fromCompanyBrancheListtoPrintableString(
      List<CompanyBranch> ListOfCompanyBranche) {
    String listOfCompanyBranche = "[";
    for (CompanyBranch element in ListOfCompanyBranche) {
      listOfCompanyBranche += "${element.toPrintableString()},";
    }
    listOfCompanyBranche += "]";
    return listOfCompanyBranche;
  }
}
