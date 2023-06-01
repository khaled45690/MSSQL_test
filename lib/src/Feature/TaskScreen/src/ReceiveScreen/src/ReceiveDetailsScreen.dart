// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../../../../DataTypes/ReceiptDetails.dart';
import '../../../../../MainWidgets/BottonSheets/searchButtonSheetForCurrency.dart';
import '../../../../../MainWidgets/CustomButton.dart';
import '../../../../../MainWidgets/CustomElementSelector.dart';
import 'Controller/ReceiveDetailsScreenController.dart';
import 'Widgets/OperationTypeRadioGroup.dart';
import 'Widgets/ReceiptDetailsInfo.dart';
import 'Widgets/ReceiptSeals.dart';

class ReceiveDetailsScreen extends StatefulWidget {
  final Function(ReceiptDetails receiptDetails) addReceiptDetails;
  final int receiptNo , receiptRowNo;
  const ReceiveDetailsScreen(this.addReceiptDetails, this.receiptNo,this.receiptRowNo,
      {super.key});

  @override
  State<ReceiveDetailsScreen> createState() => _ReceiveDetailsScreenState();
}

class _ReceiveDetailsScreenState extends ReceiveDetailsScreenController {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          key: key,
          margin: const EdgeInsets.only(top: 50, right: 20, left: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ReceiptSeals(onTextChange,
                    sealTotextEditingController: sealTotextEditingController),
                OperationTypeRadioGroup(
                    radioGroupValue: receiptDetails.F_Currency_Type,
                    onRadioChangeCallback:
                        onRadioChangeCallbackForCurrencyTypes),
                CustomElementSelector(
                  text: "نوع العملة",
                  selectedElementText:receiptDetails.F_Currency_Id.F_CURRANCY_NAM,
                  onTap: () => searchButtonSheetForCurrency(key.currentContext!,
                      currencyList, onSelectreceiptTypeFunc),
                ),
                ReceiptDetailsInfo(
                    receiptDetails.F_Currency_Type, onTextChange),
                CustomButton("حفظ", 200, saveReceiptDetails),
          
              ],
            ),
          ),
        ),
      ),
    );
  }
}
