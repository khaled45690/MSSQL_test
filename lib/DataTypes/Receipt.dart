// F_Id

// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:typed_data';

import 'package:sql_test/DataTypes/CrewMember.dart';
import 'package:sql_test/DataTypes/CustomerBranch.dart';

import 'Bank.dart';
import 'Customer.dart';
import 'ReceiptDetails.dart';
import 'ReceiptType.dart';

class Receipt {
  int F_Id;
  int F_Recipt_No;
  Customer? F_Cust;
  String F_Note;
  String F_Note1;
  String? F_Emp_Id_D;
  CustomerBranch? F_Branch_D;
  String? F_Arrival_Time_D;
  String? F_Leaving_Time_D;
  int? F_Branch_Internal_D;
  int? Userid_Save_ID;
  String? Date_Save;
  String? Time_Save;
  String F_Date; // date of the creation of the receipt
  int F_count;
  int F_Sell_Inv_No;
  int F_SaleD;
  double F_Local_Tot;
  double F_Global_Tot;
  double F_Coin_Tot;
  String? F_Paper_No; // number of Receipt entered manually
  int F_Reviewd = 0;
  double F_totalAmount_EGP = 0;
  double F_totalFees_Amount = 0;
  Customer? F_Cust_R;
  CustomerBranch? F_Branch_R;
  int? F_Branch_Internal_R;
  ReceiptType F_Recipt_Type;
  List<CrewMember> CrewIdList;
  List<ReceiptDetails> ReceiptDetailsList;
  Uint8List? imagesAsPDF;
// ReceiptType(receiptTypeNumber: 0, receiptTypeName: "تسليم")
  Receipt({
    required this.F_Id,
    required this.F_Recipt_No,
    this.F_Cust,
    required this.F_Note,
    required this.F_Note1,
    this.F_Emp_Id_D,
    this.F_Branch_D,
    this.F_Arrival_Time_D,
    this.F_Leaving_Time_D,
    this.F_Branch_Internal_D,
    this.Userid_Save_ID,
    this.Date_Save,
    this.Time_Save,
    required this.F_Date,
    required this.F_count,
    required this.F_Sell_Inv_No,
    required this.F_SaleD,
    required this.F_Local_Tot,
    required this.F_Global_Tot,
    required this.F_Coin_Tot,
    this.F_Paper_No,
    required this.F_Reviewd,
    required this.F_totalAmount_EGP,
    required this.F_totalFees_Amount,
    this.F_Cust_R,
    this.F_Branch_R,
    required this.F_Branch_Internal_R,
    required this.F_Recipt_Type,
    required this.CrewIdList,
    required this.ReceiptDetailsList,
    this.imagesAsPDF,
  });
  factory Receipt.fromJson(Map json) {
    return Receipt(
      F_Id: json['F_Id'] ?? 0,
      F_Recipt_No: json['F_Recipt_No'] ?? 0,
      F_Cust: json['F_Cust'] == null ? null : Customer.fromJson(json['F_Cust']),
      F_Note: json['F_Note'] ?? '',
      F_Note1: json['F_Note1'] ?? '',
      F_Emp_Id_D: json['F_Emp_Id_D'],
      F_Branch_D: json['F_Branch_D'] == null
          ? null
          : CustomerBranch.fromJson(json['F_Branch_D']),
      F_Arrival_Time_D: json['F_Arrival_Time_D'],
      F_Leaving_Time_D: json['F_Leaving_Time_D'],
      F_Branch_Internal_D: json['F_Branch_Internal_D'],
      Userid_Save_ID: json['Userid_Save_ID'],
      Date_Save: json['Date_Save'],
      Time_Save: json['Time_Save'],
      F_Date: json['F_Date'] ?? DateTime.now().toString(),
      F_count: json['F_count'] ?? 1,
      F_Sell_Inv_No: json['F_Sell_Inv_No'] ?? 0,
      F_SaleD: json['F_SaleD'] ?? 0,
      F_Local_Tot: json['F_Local_Tot'] ?? 0,
      F_Global_Tot: json['F_Global_Tot'] ?? 0,
      F_Coin_Tot: json['F_Coin_Tot'] ?? 0,
      F_Reviewd: json['F_Reviewd'] ?? 0,
      F_totalAmount_EGP: json['F_totalAmount_EGP'] ?? 0,
      F_totalFees_Amount: json['F_totalFees_Amount'] ?? 0,
      F_Paper_No: json['F_Paper_No'],
      F_Cust_R:
          json['F_Cust_R'] == null ? null : Customer.fromJson(json['F_Cust_R']),
      F_Branch_R: json['F_Branch_R'] == null
          ? null
          : CustomerBranch.fromJson(json['F_Branch_R']),
      F_Branch_Internal_R: json['F_Branch_Internal_R'] ?? 0,
      F_Recipt_Type: json['F_Recipt_Type'] == null
          ? ReceiptType(receiptTypeNumber: 0, receiptTypeName: "تسليم")
          : ReceiptType.fromJson(json['F_Recipt_Type']),
      CrewIdList: json['CrewIdList'] == null
          ? []
          : CrewMember.fromJsonListToCrewMemberList(json['CrewIdList']),
      ReceiptDetailsList: json['ReceiptDetailsList'] == null
          ? []
          : ReceiptDetails.fromJsonListToReceiptDetailsList(
              json['ReceiptDetailsList']),
      imagesAsPDF: json['imagesAsPDF'] == null
          ? null
          : Uint8List.fromList(json['imagesAsPDF'].cast<int>()),
    );
  }

  Map toJson() {
    return {
      "F_Id": F_Id,
      "F_Recipt_No": F_Recipt_No,
      "F_Cust": F_Cust?.toJson(),
      "F_Note": F_Note,
      "F_Note1": F_Note1,
      "F_Emp_Id_D": F_Emp_Id_D,
      "F_Branch_D": F_Branch_D?.toJson(),
      "F_Arrival_Time_D": F_Arrival_Time_D,
      "F_Leaving_Time_D": F_Leaving_Time_D,
      "F_Branch_Internal_D": F_Branch_Internal_D,
      "Userid_Save_ID": Userid_Save_ID,
      "Date_Save": Date_Save,
      "Time_Save": Time_Save,
      "F_Date": F_Date,
      "F_count": F_count,
      "F_Sell_Inv_No": F_Sell_Inv_No,
      "F_SaleD": F_SaleD,
      "F_Local_Tot": F_Local_Tot,
      "F_Global_Tot": F_Global_Tot,
      "F_Coin_Tot": F_Coin_Tot,
      "F_Reviewd": F_Reviewd,
      "F_totalAmount_EGP": F_totalAmount_EGP,
      "F_totalFees_Amount": F_totalFees_Amount,
      "F_Paper_No": F_Paper_No,
      "F_Cust_R": F_Cust_R?.toJson(),
      "F_Branch_R": F_Branch_R?.toJson(),
      "F_Branch_Internal_R": F_Branch_Internal_R,
      "F_Recipt_Type": F_Recipt_Type.toJson(),
      "CrewIdList": CrewMember.fromCrewMemberListToJsonList(CrewIdList),
      "ReceiptDetailsList":
          ReceiptDetails.fromReceiptDetailsListToJsonList(ReceiptDetailsList),
      "imagesAsPDF": imagesAsPDF,
    };
  }

  String toJsonString() {
    return jsonEncode({
      "F_Id": F_Id,
      "F_Recipt_No": F_Recipt_No,
      "F_Cust": F_Cust?.toJson(),
      "F_Note": F_Note,
      "F_Note1": F_Note1,
      "F_Emp_Id_D": F_Emp_Id_D,
      "F_Branch_D": F_Branch_D?.toJson(),
      "F_Arrival_Time_D": F_Arrival_Time_D,
      "F_Leaving_Time_D": F_Leaving_Time_D,
      "F_Branch_Internal_D": F_Branch_Internal_D,
      "Userid_Save_ID": Userid_Save_ID,
      "Date_Save": Date_Save,
      "Time_Save": Time_Save,
      "F_Date": F_Date,
      "F_count": F_count,
      "F_Sell_Inv_No": F_Sell_Inv_No,
      "F_SaleD": F_SaleD,
      "F_Local_Tot": F_Local_Tot,
      "F_Global_Tot": F_Global_Tot,
      "F_Coin_Tot": F_Coin_Tot,
      "F_Reviewd": F_Reviewd,
      "F_totalAmount_EGP": F_totalAmount_EGP,
      "F_totalFees_Amount": F_totalFees_Amount,
      "F_Paper_No": F_Paper_No,
      "F_Cust_R": F_Cust_R?.toJson(),
      "F_Branch_R": F_Branch_R?.toJson(),
      "F_Branch_Internal_R": F_Branch_Internal_R,
      "F_Recipt_Type": F_Recipt_Type.toJson(),
      "CrewIdList": CrewMember.fromCrewMemberListToJsonList(CrewIdList),
      "ReceiptDetailsList":
          ReceiptDetails.fromReceiptDetailsListToJsonList(ReceiptDetailsList),
      "imagesAsPDF": imagesAsPDF,
    });
  }

  String toPrintableString() {
    return "{"
        "F_Id: $F_Id,"
        "F_Recipt_No: $F_Recipt_No,"
        "F_Cust: ${F_Cust?.toPrintableString()},"
        "F_Note: $F_Note,"
        "F_Note1: $F_Note1,"
        "F_Emp_Id_D: $F_Emp_Id_D,"
        "F_Branch_D: ${F_Branch_D?.toPrintableString()},"
        "F_Arrival_Time_D: $F_Arrival_Time_D,"
        "F_Leaving_Time_D: $F_Leaving_Time_D,"
        "F_Branch_Internal_D: $F_Branch_Internal_D,"
        "Userid_Save_ID: $Userid_Save_ID,"
        "Date_Save: $Date_Save,"
        "Time_Save: $Time_Save,"
        "F_Date: $F_Date,"
        "F_count: $F_count,"
        "F_Sell_Inv_No: $F_Sell_Inv_No,"
        "F_SaleD: $F_SaleD,"
        "F_Local_Tot: $F_Local_Tot,"
        "F_Global_Tot: $F_Global_Tot,"
        "F_Coin_Tot: $F_Coin_Tot,"
        "F_Reviewd: $F_Reviewd,"
        "F_totalAmount_EGP: $F_totalAmount_EGP,"
        "F_totalFees_Amount: $F_totalFees_Amount,"
        "F_Paper_No: $F_Paper_No,"
        "F_Cust_R: ${F_Cust_R?.toPrintableString()},"
        "F_Branch_R: ${F_Branch_R?.toPrintableString()},"
        "F_Branch_Internal_R: $F_Branch_Internal_R,"
        "F_Recipt_Type: ${F_Recipt_Type.toPrintableString()},"
        "CrewIdList: ${CrewMember.fromCrewMemberListtoPrintableString(CrewIdList)},"
        "ReceiptDetailsList: ${ReceiptDetails.fromReceiptDetailsListtoPrintableString(ReceiptDetailsList)},"
        "imagesAsPDF: $imagesAsPDF,"
        "}";
  }

  static List<Receipt> fromJsonStringListToReceiptList(
      String ListOfJsonString) {
    List listOfJson = jsonDecode(ListOfJsonString);
    List<Receipt> listOfUsers = [];

    for (var element in listOfJson) {
      listOfUsers.add(Receipt.fromJson(element));
    }
    return listOfUsers;
  }

  static List<Receipt> fromJsonListToReceiptList(List listOfJson) {
    List<Receipt> listOfUsers = [];

    for (var element in listOfJson) {
      listOfUsers.add(Receipt.fromJson(element));
    }
    return listOfUsers;
  }

  static List fromReceiptListToJsonList(List<Receipt> ListOfReceipt) {
    List listOfReceipt = [];

    for (var element in ListOfReceipt) {
      listOfReceipt.add(element.toJson());
    }
    return listOfReceipt;
  }

  static String fromReceiptListToJsonListString(List<Receipt> ListOfReceipt) {
    List listOfReceipt = [];

    for (var element in ListOfReceipt) {
      listOfReceipt.add(element.toJson());
    }
    return jsonEncode(listOfReceipt);
  }

  static String fromReceiptListtoPrintableString(List<Receipt> ListOfReceipt) {
    String listOfReceipt = "[";
    for (Receipt element in ListOfReceipt) {
      listOfReceipt += "${element.toPrintableString()},";
    }
    listOfReceipt += "]";
    return listOfReceipt;
  }
}
