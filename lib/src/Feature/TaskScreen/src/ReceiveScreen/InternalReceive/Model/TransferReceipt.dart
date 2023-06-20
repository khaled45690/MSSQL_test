//ReceiptInternalReceiveData


// ignore_for_file: non_constant_identifier_names, file_names

import 'dart:convert';

// [{"F_Trans_Id":1, "Post_Status":0, "F_Recipt_No":5, "F_Paper_No":123456777}]
class TransferReceipt {
  int F_Trans_Id;
  int Post_Status;
  int F_Recipt_No;
  String F_Paper_No;
   // collection of F_Paper_No numbers

   
  TransferReceipt(
      {required this.F_Trans_Id,
      required this.Post_Status,
      required this.F_Paper_No,
      required this.F_Recipt_No});

  factory TransferReceipt.fromJson(Map json) {
    return TransferReceipt(
      F_Trans_Id: json['F_Trans_Id'] ,
      F_Recipt_No: json['F_Recipt_No'],
      F_Paper_No: json['F_Paper_No'].toString(),
      Post_Status: json['Post_Status'],
    );
  }

  Map toJson() {
    return {
      "F_Recipt_No": F_Recipt_No,
      "F_Paper_No": F_Paper_No,
      "F_Trans_Id": F_Trans_Id,
      "Post_Status": Post_Status,
    };
  }

  String toJsonString() {
    return jsonEncode({
      "F_Recipt_No": F_Recipt_No,
      "F_Paper_No": F_Paper_No,
      "F_Trans_Id": F_Trans_Id,
      "Post_Status": Post_Status,
    });
  }

  String toPrintableString() {
    // image data will not be printed as it will take huge amount of space
    return "{"
        "F_Recipt_No: $F_Recipt_No,"
        " F_Paper_No: $F_Paper_No,"
        " F_Trans_Id: $F_Trans_Id,"
        " Post_Status: $Post_Status,"
        "}";
  }

  static List<TransferReceipt> fromJsonStringListToTransferReceiptList(
      String ListOfJsonString) {
    List listOfJson = jsonDecode(ListOfJsonString);
    List<TransferReceipt> listOfUsers = [];

    for (var element in listOfJson) {
      listOfUsers.add(TransferReceipt.fromJson(element));
    }
    return listOfUsers;
  }

  static fromTransferReceiptListToJsonList(
      List<TransferReceipt> ListOfTransferReceipt) {
    List listOfUsers = [];

    for (var element in ListOfTransferReceipt) {
      listOfUsers.add(element.toJson());
    }
    return listOfUsers;
  }

  static fromTransferReceiptListToJsonListString(
      List<TransferReceipt> ListOfTransferReceipt) {
    List listOfTransferReceipt = [];

    for (var element in ListOfTransferReceipt) {
      listOfTransferReceipt.add(element.toJson());
    }
    return jsonEncode(listOfTransferReceipt);
  }

  static String fromTransferReceiptListtoPrintableString(
      List<TransferReceipt> ListOfTransferReceipt) {
    String listOfTransferReceipt = "[";
    for (TransferReceipt element in ListOfTransferReceipt) {
      listOfTransferReceipt += "${element.toPrintableString()},";
    }
    listOfTransferReceipt += "]";
    return listOfTransferReceipt;
  }
}
