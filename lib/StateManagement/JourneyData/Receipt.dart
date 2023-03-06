// F_Id

// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:ffi';

@json
class Receipt {
  int? F_Id;
  int? F_Recipt_No;
  int? F_Cust_Id;
  String F_Note = "";
  String F_Note1 = "";
  String? F_Emp_Id_D;
  int? F_Bank_Id_D;
  int? F_Branch_Id_D;
  String? F_Arrival_Time_D;
  String? F_Leaving_Time_D;
  int? Userid_Save_ID;
  String Date_Save = DateTime.now().toString();
  String Time_Save = DateTime.now().toString();
  String? F_Date; // date of the creation of the receipt
  int F_count = 1;
  int F_Sell_Inv_No = 0;
  int? F_SaleD;
  double F_Local_Tot = 0.0;
  double F_Global_Tot = 0.0;
  double F_Coin_Tot = 0.0;
  String? F_Paper_No; // number of Receipt entered manually
  int F_Reviewd = 0;
  double F_totalAmount_EGP = 0;
  double F_totalFees_Amount = 0;
  int? F_Branch_Internal_D;
  int? F_Branch_Internal_R;
  int F_Recipt_Type = 0;
  //Attachment files parameter must be added

  Receipt({
    this.F_Id,
    this.F_Recipt_No,
    this.F_Cust_Id,
    this.F_Emp_Id_D,
    this.F_Bank_Id_D,
    this.F_Branch_Id_D,
    this.F_Arrival_Time_D,
    this.F_Leaving_Time_D,
    this.Userid_Save_ID,
    this.F_Date,
    this.F_SaleD,
    this.F_Paper_No,
    this.F_Branch_Internal_D,
    this.F_Branch_Internal_R,
  });

  // factory Receipt.fromJson(Map json) {

  //   return Receipt(
  //     F_Id: json['F_Id'],
  //     F_Recipt_No: json['F_Recipt_No'],
  //     F_Cust_Id: json['F_Cust_Id'],
  //     F_Emp_Id_D: json['F_Emp_Id_D'],
  //     F_Bank_Id_D: json['F_Bank_Id_D'],
  //     F_Branch_Id_D: json['F_Branch_Id_D'],
  //     F_Arrival_Time_D: json['F_Arrival_Time_D'],
  //     F_Arrival_Time_D: json['F_Arrival_Time_D'],
  //     F_Arrival_Time_D: json['F_Arrival_Time_D'],
  //     F_Arrival_Time_D: json['F_Arrival_Time_D'],
  //     F_Arrival_Time_D: json['F_Arrival_Time_D'],
  //     F_Arrival_Time_D: json['F_Arrival_Time_D'],
  //     F_Arrival_Time_D: json['F_Arrival_Time_D'],
  //   );
  // }
}
