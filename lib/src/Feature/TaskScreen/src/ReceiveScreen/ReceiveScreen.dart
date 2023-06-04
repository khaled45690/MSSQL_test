import 'package:flutter/material.dart';

import '../../../../DataTypes/Receipt.dart';
import '../../../../Utilities/VariableCodes.dart';
import '../../Widgets/InternalAndExternalReceiveRadioButton.dart';
import 'ExternalReceive/ExternalReceive.dart';
import 'InternalReceive/InternalRecieve.dart';

class ReceiveScreen extends StatelessWidget {
  final List<Receipt> receipts;
  final Function(
          Receipt receiptParameter, int receiptIndex, bool isFinalyEdited)
      editReceiptInJouerny;
  final Receipt receipt;
  final Function(Receipt receiptParameter) saveTempReceipt,
      saveReceiptInJouerny;
  final bool isAddingNewReceipt;
  final Function() addNewReceipt;
  final int receiveradioGroupValue;
  final Function(int radioGroupValue) receiveOnRadioChangeCallback;
  const ReceiveScreen(
      {required this.receipts,
      required this.editReceiptInJouerny,
      required this.receipt,
      super.key,
      required this.saveTempReceipt,
      required this.saveReceiptInJouerny,
      required this.isAddingNewReceipt,
      required this.receiveradioGroupValue,
      required this.addNewReceipt,
      required this.receiveOnRadioChangeCallback});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InternalAndExternalReceiveRadioButton(
            radioGroupValue: receiveradioGroupValue,
            onRadioChangeCallback: receiveOnRadioChangeCallback),
        receiveradioGroupValue == InternalReceiving
            ? InternalReceive(
                receipts: receipts, editReceiptInJouerny: editReceiptInJouerny)
            : ExternalReceive(
                receipts: receipts,
                editReceiptInJouerny: editReceiptInJouerny,
                receipt: receipt,
                saveTempReceipt: saveTempReceipt,
                saveReceiptInJouerny: saveReceiptInJouerny,
                isEnabled: isAddingNewReceipt,
                addNewReceipt: addNewReceipt,
              )
      ],
    );
  }
}
