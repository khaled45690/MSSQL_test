// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class CrewMember {
  int F_EmpID;
  String F_EmpName;

    CrewMember({
    required this.F_EmpID,
    required this.F_EmpName, 
  });

  factory CrewMember.fromJson(Map json) {
    return CrewMember(
      F_EmpID: json['F_CURRANCY_ID'],
      F_EmpName: json['F_EmpName'],
    );
  }


  Map toJson() {
    return {
      "F_EmpID": F_EmpID,
      "F_EmpName": F_EmpName,
    };
  }

  String toJsonString() {
    return jsonEncode({
      "F_EmpID": F_EmpID,
      "F_EmpName": F_EmpName,
    });
  }

  String toPrintableString() {
    return "{"
        "F_EmpID: $F_EmpID,"
        " F_EmpName: $F_EmpName,"
        "}";
  }

  static List<CrewMember> fromJsonStringListToCrewMemberList(
      String ListOfJsonString) {
    List listOfJson = jsonDecode(ListOfJsonString);
    List<CrewMember> listOfUsers = [];

    for (var element in listOfJson) {
        listOfUsers.add(CrewMember.fromJson(element));
    }
    return listOfUsers;
  }

  static fromCrewMemberListToJsonList(List<CrewMember> ListOfCrewMember) {
    List listOfUsers = [];

    for (var element in ListOfCrewMember) {
      listOfUsers.add(element.toJson());
    }
    return listOfUsers;
  }

  static fromCrewMemberListToJsonListString(List<CrewMember> ListOfCrewMember) {
    List listOfCrewMember = [];

    for (var element in ListOfCrewMember) {
      listOfCrewMember.add(element.toJson());
    }
    return jsonEncode(listOfCrewMember);
  }

  static String fromCrewMemberListtoPrintableString(
      List<CrewMember> ListOfCrewMember) {
    String listOfCrewMember = "[";
    for (CrewMember element in ListOfCrewMember) {
      listOfCrewMember += "${element.toPrintableString()},";
    }
    listOfCrewMember += "]";
    return listOfCrewMember;
  }
}
