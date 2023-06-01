// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sql_test/src/DataTypes/Currency.dart';
import 'package:sql_test/src/Utilities/Extentions.dart';
import 'package:sql_test/src/Utilities/VariableCodes.dart';

import '../../../../../../DataTypes/ReceiptDetails.dart';
import '../../../../../../Utilities/Prefs.dart';
import '../../../../../../Utilities/Strings.dart';
import '../ReceiveDetailsScreen.dart';

abstract class ReceiveDetailsScreenController
    extends State<ReceiveDetailsScreen> {
  late GlobalKey key;
  ReceiptDetails receiptDetails = ReceiptDetails.fromJson({});
  late List<Currency> currencyList;
  bool isCoins = false;
  TextEditingController sealTotextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    key = GlobalKey();
    String currencyData = Prefs.getString(currencyInfo)!;
    currencyList = Currency.fromJsonStringListToCurrencyList(currencyData);
    receiptDetails.F_Recipt_No = widget.receiptNo;
    receiptDetails.F_RowNo = widget.receiptRowNo;
  }

  bool isAddingNewReceipt = false;
  onRadioChangeCallback(bool radioGroupValue) {
    isCoins = radioGroupValue;
    setState(() {});
  }

  onRadioChangeCallbackForCurrencyTypes(int radioGroupValue) {
    if ((receiptDetails.F_Currency_Type == LocalCurrency &&
            radioGroupValue != CoinsCurrency) ||
        (receiptDetails.F_Currency_Type == ForeignCurrency &&
            radioGroupValue != CoinsCurrency)) return;

    if (radioGroupValue == LocalCurrency || radioGroupValue == CoinsCurrency) {
      receiptDetails.F_Currency_Id =
          Currency(F_CURRANCY_ID: EGP, F_CURRANCY_NAM: "جنيه مصرى");
    } else if (radioGroupValue == ForeignCurrency) {
      receiptDetails.F_Currency_Id =
          Currency(F_CURRANCY_ID: USD, F_CURRANCY_NAM: "دولار امريكى");
    }
    receiptDetails.F_Currency_Type = radioGroupValue;
    receiptDetails.F_Uinte_Id = radioGroupValue;
    setState(() {});
  }

  onTextChange(String variableName, String value) {
    if (value == '') {
      if (variableName == "F_BankNote_No") receiptDetails.F_BankNote_No = 0;
      return;
    }

    switch (variableName) {
      case "F_Seal_No_From":
        sealTotextEditingController.text = value;
        receiptDetails.F_Seal_No_From = value;
        receiptDetails.F_Seal_No_To = value;
        break;
      case "F_Seal_No_To":
        receiptDetails.F_Seal_No_To = value;
        break;
      case "NoOfBags":
        int? valueINT = int.tryParse(value);
        valueINT ?? context.snackBar(pleaseEnterNumber, color: Colors.red);
        if (valueINT == null) break;
        receiptDetails.F_Bags_No = valueINT;
        break;
      case "F_Pack_Class":
        int? valueINT = int.tryParse(value);
        valueINT ?? context.snackBar(pleaseEnterNumber, color: Colors.red);
        if (valueINT == null) break;
        receiptDetails.F_Pack_Class = valueINT;
        break;
      case "TotalInEGP":
        double? valueINT = double.tryParse(value);
        valueINT ?? context.snackBar(pleaseEnterNumber, color: Colors.red);
        if (valueINT == null) break;
        receiptDetails.F_Total_val = valueINT;
        break;
      case "F_Pack_No":
        int? valueINT = int.tryParse(value);
        valueINT ?? context.snackBar(pleaseEnterNumber, color: Colors.red);
        if (valueINT == null) break;
        receiptDetails.F_Pack_No = valueINT;
        break;
      case "F_BankNote_Class":
        receiptDetails.F_BankNote_Class = value;
        break;
      case "F_BankNote_No":
        int? valueINT = int.tryParse(value);
        valueINT ?? context.snackBar(pleaseEnterNumber, color: Colors.red);
        if (valueINT == null) break;
        receiptDetails.F_BankNote_No = valueINT;
        break;
      case "F_Convert_Factor":
        double? valueDouble = double.tryParse(value);
        valueDouble ?? context.snackBar(pleaseEnterNumber, color: Colors.red);
        if (valueDouble == null) break;
        receiptDetails.F_Convert_Factor = valueDouble;
        break;
      default:
    }
    setState(() {});
  }

  onSelectreceiptTypeFunc(Currency currency) {
    receiptDetails.F_Currency_Id = currency;
    if (currency.F_CURRANCY_ID == EGP) {
      receiptDetails.F_Currency_Type = LocalCurrency;
    } else {
      receiptDetails.F_Currency_Type = ForeignCurrency;
    }
    setState(() {});
  }

  saveReceiptDetails() {
    if (_nullCheck()) return;
    if (_moneyDataCheck()) return;

    widget.addReceiptDetails(receiptDetails);
    Navigator.pop(context);
  }

  bool _nullCheck() {
    bool check = false;
    if (receiptDetails.F_Seal_No_From == null ||
        receiptDetails.F_Seal_No_To == null) {
      context.snackBar(sealsOrCurrencyNotSelected, color: Colors.red);
      check = true;
    }

    return check;
  }

  bool _moneyDataCheck() {
    bool check = false;
    switch (receiptDetails.F_Currency_Type) {
      case CoinsCurrency:
        check = _handleCoinInfoBeforeSave();
        break;
      case LocalCurrency:
        check = _handleLocalCurrencyInfoBeforeSave();
        break;
      case ForeignCurrency:
        check = _handleForeignCurrencyInfoBeforeSave();
        break;
      default:
    }
    return check;
  }

  bool _handleCoinInfoBeforeSave() {
    bool check = false;
    if (receiptDetails.F_Bags_No == 0 ||
        receiptDetails.F_BankNote_Class == null) {
      check = true;
      context.snackBar(noBagsOrBankClassOrEGPNotEntered, color: Colors.red);
    }
    return check;
  }

  bool _handleLocalCurrencyInfoBeforeSave() {
    bool check = false;
    if (receiptDetails.F_Pack_No == 0 ||
        receiptDetails.F_Pack_Class == 0 ||
        receiptDetails.F_Bags_No == 0) {
      check = true;
      context.snackBar(noBagsOrnoPapersOrBankNoteClassOrPackClass,
          color: Colors.red);
    }
    // to calculate the total number we multiply by the number of packs with the currency number with number of bags and
    //// add to the number of lone papers multiplied by the currency number
    receiptDetails.F_Total_val = ((receiptDetails.F_Pack_No *
                receiptDetails.F_Pack_Class *
                receiptDetails.F_Bags_No *
                100) +
            (receiptDetails.F_BankNote_No * receiptDetails.F_Pack_Class))
        .toDouble();
    receiptDetails.F_EGP_Amount = receiptDetails.F_Total_val.toDouble();
    return check;
  }

  bool _handleForeignCurrencyInfoBeforeSave() {
    bool check = false;

    if (receiptDetails.F_Pack_No == 0 ||
        receiptDetails.F_Pack_Class == 0 ||
        receiptDetails.F_Bags_No == 0 ||
        receiptDetails.F_Convert_Factor == 0) {
      check = true;
      context.snackBar(noBagsOrnoPapersOrBankNoteClassOrPackClassOrFactorNo,
          color: Colors.red);
    }
    receiptDetails.F_Total_val = ((receiptDetails.F_Pack_No *
                receiptDetails.F_Pack_Class *
                receiptDetails.F_Bags_No *
                100) +
            (receiptDetails.F_BankNote_No * receiptDetails.F_Pack_Class))
        .toDouble();

    receiptDetails.F_EGP_Amount =
        (receiptDetails.F_Total_val * receiptDetails.F_Convert_Factor);
    return check;
  }
}
