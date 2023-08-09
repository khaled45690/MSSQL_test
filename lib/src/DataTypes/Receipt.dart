// F_Id

// ignore_for_file: non_constant_identifier_names, file_names, depend_on_referenced_packages

import 'dart:convert';
import 'dart:typed_data';

import 'package:sql_test/src/DataTypes/CrewMember.dart';
import 'package:sql_test/src/DataTypes/CustomerBranch.dart';

import '../Utilities/Prefs.dart';
import '../Utilities/Strings.dart';
import '../Utilities/VariableCodes.dart';
import 'CompanyBranch.dart';
import 'Customer.dart';
import 'ReceiptDetails.dart';
import 'ReceiptType.dart';
import 'package:convert/convert.dart';

import 'User.dart';

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
  CompanyBranch? companyBranch;
  bool isDeliveredToAnotherDriver;
  bool isSavedInDatabase;
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
    required this.isSavedInDatabase,
    this.companyBranch,
    required this.isDeliveredToAnotherDriver,
    this.imagesAsPDF,
  });
  factory Receipt.fromJson(Map json, {isUpdatingFromDatabase = false}) {
    List Recipt_Type = ["تسليم", "فرز", "محصنة"];

    Customer? cust = _customerSetter(json['F_Cust_Id']);
    Customer? cust_R = _customerSetter(json['F_Bank_Id_R']);

    // this is used to just change the time String to fit in the app
    // as it doesn't come as a time suitable for the app
    if (isUpdatingFromDatabase) {
      DateTime arrivalTime = DateTime.parse(json['F_Arrival_Time_D']),
          leavingTime = DateTime.parse(json['F_Leaving_Time_D']);
      String arrivalHour = arrivalTime.hour > 12
          ? (arrivalTime.hour - 12) > 10
              ? "${(arrivalTime.hour - 12)}"
              : "0${(arrivalTime.hour - 12)}"
          : (arrivalTime.hour) > 10
              ? "${(arrivalTime.hour)}"
              : "0${(arrivalTime.hour)}";
      String arrivalMinute = arrivalTime.minute > 10
          ? "${(arrivalTime.minute)}"
          : "0${(arrivalTime.minute)}";
      String leavingHour = leavingTime.hour > 12
          ? (leavingTime.hour - 12) > 10
              ? "${(leavingTime.hour - 12)}"
              : "0${(leavingTime.hour - 12)}"
          : (leavingTime.hour) > 10
              ? "${(leavingTime.hour)}"
              : "0${(leavingTime.hour)}";
      String leavingMinute = leavingTime.minute > 10
          ? "${(leavingTime.minute)}"
          : "0${(leavingTime.minute)}";
      json['F_Arrival_Time_D'] =
          "$arrivalHour:$arrivalMinute ${arrivalTime.hour > 11 ? "PM" : "AM"}";
      json['F_Leaving_Time_D'] =
          "$leavingHour:$leavingMinute ${leavingTime.hour > 11 ? "PM" : "AM"}";
    }

    return Receipt(
      F_Id: json['F_Id'] ?? 0,
      F_Recipt_No: json['F_Recipt_No'] ?? 0,
      F_Cust: _customerMainSetter(json, cust),
      F_Note: json['F_Note']?.toString() ?? '',
      F_Note1: json['F_Note1']?.toString() ?? '',
      F_Emp_Id_D: json['F_Emp_Id_D'],
      F_Branch_D: _customerBranchMainSetter(json, cust),
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
      F_Paper_No: json['F_Paper_No']?.toString(),
      F_Cust_R: _customerRSetter(json),
      F_Branch_R: _customerBranchRSetter(json, cust_R),
      F_Branch_Internal_R: json['F_Branch_Internal_R'] ?? 0,
      F_Recipt_Type: _receiptTypeSetter(json, Recipt_Type),
      CrewIdList: _crewSetter(json),
      ReceiptDetailsList: receiptDetailsListSetter(json),
      imagesAsPDF: pdfSetter(json),
      isSavedInDatabase: json['isSavedInDatabase'] ?? false,
      companyBranch: companyBranchSetter(json),
      isDeliveredToAnotherDriver: json['isDeliveredToAnotherDriver'] ?? false,
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
      "isSavedInDatabase": isSavedInDatabase,
      "companyBranch": companyBranch?.toJson(),
      "isDeliveredToAnotherDriver": isDeliveredToAnotherDriver,
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
      "isSavedInDatabase": isSavedInDatabase,
      "companyBranch": companyBranch?.toJson(),
      "isDeliveredToAnotherDriver": isDeliveredToAnotherDriver,
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
        "imagesAsPDF: ${imagesAsPDF == null? "there is no image" : "there is an image"},"
        "isSavedInDatabase: $isSavedInDatabase"
        "companyBranch: ${companyBranch?.toJson()}"
        "isDeliveredToAnotherDriver: $isDeliveredToAnotherDriver"
        "}";
  }

  static List<Receipt> fromJsonStringListToReceiptList(String ListOfJsonString,
      {isUpdatingFromDatabase = false}) {
    List listOfJson = jsonDecode(ListOfJsonString);
    List<Receipt> listOfUsers = [];

    for (var element in listOfJson) {
      listOfUsers.add(Receipt.fromJson(element,
          isUpdatingFromDatabase: isUpdatingFromDatabase));
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

  static Customer? _customerSetter(var CustomerId) {
    if (CustomerId == null) return null;
    Customer? returnedCustomer;
    if (CustomerId is int) {
      String? customerListString = Prefs.getString(customersInfo);
      if (customerListString != null) {
        List customerList =
            Customer.fromJsonStringListToCustomerList(customerListString);
        for (Customer customer in customerList) {
          if (customer.CustID == CustomerId) {
            returnedCustomer = customer;
            break;
          }
        }
      }
    } else {
      returnedCustomer = Customer.fromJson(CustomerId);
    }

    return returnedCustomer;
  }

  static CustomerBranch? _customerBranchSetter(
      var customerBranch, List<CustomerBranch> customerBranchList) {
    CustomerBranch? returnedCustomerBranch;
    if (customerBranch == null) return null;
    if (customerBranch is int) {
      for (var i = 0; i < customerBranchList.length; i++) {
        if (customerBranch == customerBranchList[i].F_Branch_Id) {
          returnedCustomerBranch = customerBranchList[i];
        }
      }
    } else {
      returnedCustomerBranch = CustomerBranch.fromJson(customerBranch);
    }
    return returnedCustomerBranch;
  }

  static List<CrewMember> _crewMemberSetter(Map json) {
    List<CrewMember> crewMemberList = [];
    List<User> allUsers = User.fromJsonStringListToUserList(
        Prefs.getString(allUsersFromLocaleDataBase)!);
    for (var i = 0; i < maxEmpSize; i++) {
      if (json["F_Team${i + 1}"] != null) {
        for (User user in allUsers) {
          if (user.F_EmpID == json["F_Team${i + 1}"]) {
            CrewMember crewMember =
                CrewMember(F_EmpID: user.F_EmpID, F_EmpName: user.F_EmpName);
            crewMemberList.add(crewMember);
          }
        }
      }
    }
    return crewMemberList;
  }

  static Customer? _customerRSetter(Map json) {
    if (json['F_Bank_Id_R'] != null) {
      return _customerSetter(json['F_Bank_Id_R']);
    } else {
      if (json['F_Cust_R'] == null) {
        return null;
      } else {
        return Customer.fromJson(json['F_Cust_R']);
      }
    }
  }

  static CustomerBranch? _customerBranchRSetter(Map json, Customer? cust_R) {
    if (json['F_Branch_R'] == null) {
      return _customerBranchSetter(
          json['F_Branch_Id_R'], cust_R == null ? [] : cust_R.CustomerBranches);
    } else {
      return CustomerBranch.fromJson(json['F_Branch_R']);
    }
  }

  static ReceiptType _receiptTypeSetter(Map json, List Recipt_Type) {
    if (json['F_Recipt_Type'] == null) {
      return ReceiptType(receiptTypeNumber: 0, receiptTypeName: "تسليم");
    } else {
      if (json['F_Recipt_Type'] is int) {
        return ReceiptType(
            receiptTypeNumber: json['F_Recipt_Type'],
            receiptTypeName: Recipt_Type[json['F_Recipt_Type']]);
      } else {
        return ReceiptType.fromJson(json['F_Recipt_Type']);
      }
    }
  }

  static Customer? _customerMainSetter(Map json, Customer? cust) {
    if (json['F_Cust_Id'] != null) {
      return cust;
    } else {
      if (json['F_Cust'] == null) {
        return null;
      } else {
        return Customer.fromJson(json['F_Cust']);
      }
    }
  }

  static List<CrewMember> _crewSetter(Map json) {
    if (json['CrewIdList'] == null) {
      if (json['F_Team1'] != null) {
        return _crewMemberSetter(json);
      } else {
        return [];
      }
    } else {
      return CrewMember.fromJsonListToCrewMemberList(json['CrewIdList']);
    }
  }

  static List<ReceiptDetails> receiptDetailsListSetter(Map json) {
    if (json['ReceiptDetailsList'] == null) {
      return [];
    } else {
      return ReceiptDetails.fromJsonListToReceiptDetailsList(
          json['ReceiptDetailsList']);
    }
  }

  static Uint8List? pdfSetter(Map json) {
    if (json["F_Attachment"] != null) {
      return Uint8List.fromList(hex.decode(json['F_Attachment']));
    } else {
      if (json['imagesAsPDF'] == null) {
        return null;
      } else {
        return Uint8List.fromList(json['imagesAsPDF'].cast<int>());
      }
    }
  }

  static CustomerBranch? _customerBranchMainSetter(Map json, Customer? cust) {
    if (json['F_Branch_D'] == null) {
      return _customerBranchSetter(
          json['F_Branch_Id_D'], cust == null ? [] : cust.CustomerBranches);
    } else {
      return CustomerBranch.fromJson(json['F_Branch_D']);
    }
  }

  static CompanyBranch? companyBranchSetter(Map json) {
    if (json['F_Sort_Loc_Id'] != null) {
      CompanyBranch? companyBranch;
      String? companyBranchListString = Prefs.getString(companyBranchesInfo);
      List companyBranchList =
          CompanyBranch.fromJsonStringListToCompanyBrancheList(
              companyBranchListString!);
      for (CompanyBranch element in companyBranchList) {
        if (element.F_Sort_Loc_Id == json['F_Sort_Loc_Id']) {
          companyBranch = element;
        }
      }
      return companyBranch;
    } else if (json['companyBranch'] != null) {
      return CompanyBranch.fromJson(json['companyBranch']);
    }
    return null;
  }
}
