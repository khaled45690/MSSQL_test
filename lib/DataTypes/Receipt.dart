// F_Id

// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:ffi';

import 'package:sql_test/DataTypes/CustomerBranch.dart';

import 'Bank.dart';
import 'CrewMember.dart';
import 'Customer.dart';

@json
class Receipt {
  int? F_Id;
  int? F_Recipt_No;
  Customer? F_Cust;
  String F_Note = "";
  String F_Note1 = "";
  String? F_Emp_Id_D;
  Bank? F_Bank_D;
  CustomerBranch? F_Branch_D;
  String? F_Arrival_Time_D;
  String? F_Leaving_Time_D;
  int? F_Branch_Internal_D;
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
  Customer? F_Cust_R;
  CustomerBranch? F_Branch_R;
  int? F_Branch_Internal_R;
  int F_Recipt_Type = 0;
  List<CrewMember> CrewIdList = [];
  //Attachment files parameter must be added
}
