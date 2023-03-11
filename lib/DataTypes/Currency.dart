// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class Currency {
  int F_CURRANCY_ID;
  String F_CURRANCY_NAM;

    Currency({
    required this.F_CURRANCY_ID,
    required this.F_CURRANCY_NAM, 
  });

  factory Currency.fromJson(Map json) {
    return Currency(
      F_CURRANCY_ID: json['F_CURRANCY_ID'],
      F_CURRANCY_NAM: json['F_CURRANCY_NAM'],
    );
  }


  Map toJson() {
    return {
      "F_CURRANCY_ID": F_CURRANCY_ID,
      "F_CURRANCY_NAM": F_CURRANCY_NAM,
    };
  }

  String toJsonString() {
    return jsonEncode({
      "F_CURRANCY_ID": F_CURRANCY_ID,
      "F_CURRANCY_NAM": F_CURRANCY_NAM,
    });
  }

  String toPrintableString() {
    return "{"
        "F_CURRANCY_ID: $F_CURRANCY_ID,"
        " F_CURRANCY_NAM: $F_CURRANCY_NAM,"
        "}";
  }

  static List<Currency> fromJsonStringListToCurrencyList(
      String ListOfJsonString) {
    List listOfJson = jsonDecode(ListOfJsonString);
    List<Currency> listOfUsers = [];

    for (var element in listOfJson) {
        listOfUsers.add(Currency.fromJson(element));
    }
    return listOfUsers;
  }

  static fromCurrencyListToJsonList(List<Currency> ListOfCurrency) {
    List listOfUsers = [];

    for (var element in ListOfCurrency) {
      listOfUsers.add(element.toJson());
    }
    return listOfUsers;
  }

  static fromCurrencyListToJsonListString(List<Currency> ListOfCurrency) {
    List listOfCurrency = [];

    for (var element in ListOfCurrency) {
      listOfCurrency.add(element.toJson());
    }
    return jsonEncode(listOfCurrency);
  }

  static String fromCurrencyListtoPrintableString(
      List<Currency> ListOfCurrency) {
    String listOfCurrency = "[";
    for (Currency element in ListOfCurrency) {
      listOfCurrency += "${element.toPrintableString()},";
    }
    listOfCurrency += "]";
    return listOfCurrency;
  }
}
