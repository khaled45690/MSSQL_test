// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sql_test/src/Utilities/VariableCodes.dart';

import '../../Widgets/TextFieldWithName.dart';

class ReceiptDetailsInfo extends StatelessWidget {
  final int currencyType;
  final Function(String variable, String value) onTextChange;
  const ReceiptDetailsInfo(this.currencyType, this.onTextChange, {super.key});

  @override
  Widget build(BuildContext context) {
    return currencyType == CoinsCurrency
        ? Column(
            children: [
              TextFieldWithName("عدد الحقائب",
                  onTextChangeFunction: (String value) =>
                      onTextChange("NoOfBags", value),
                  isNumber: true),
              TextFieldWithName(
                "الفئة المعدنية",
                onTextChangeFunction: (String value) =>
                    onTextChange("F_BankNote_Class", value),
              ),
            ],
          )
        : Column(
            children: [
              TextFieldWithName("عدد الاوراق",
                  onTextChangeFunction: (String value) =>
                      onTextChange("F_BankNote_No", value),
                  isNumber: true),
              TextFieldWithName("عدد الباكوهات",
                  onTextChangeFunction: (String value) =>
                      onTextChange("F_Pack_No", value),
                  isNumber: true),
              TextFieldWithName("الفئة الرقمية",
                  onTextChangeFunction: (String value) =>
                      onTextChange("F_Pack_Class", value),
                  isNumber: true),
              TextFieldWithName("عدد الحقائب",
                  onTextChangeFunction: (String value) =>
                      onTextChange("NoOfBags", value),
                  isNumber: true),

                  currencyType == ForeignCurrency? TextFieldWithName("معامل التحويل",
                  onTextChangeFunction: (String value) =>
                      onTextChange("F_Convert_Factor", value),
                  isNumber: true) : const SizedBox(),
            ],
          );
  }
}
