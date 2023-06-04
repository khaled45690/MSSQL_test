import 'package:flutter/material.dart';

import '../../../../../DataTypes/Receipt.dart';
import '../../../../../MainWidgets/CustomButton.dart';
import '../../../Widgets/ReceiptCard.dart';
import '../../../Widgets/TaskList.dart';



class ExternalReceive extends StatelessWidget {
  final List<Receipt> receipts;
  final Function(
          Receipt receiptParameter, int receiptIndex, bool isFinalyEdited)
      editReceiptInJouerny;
  final Receipt receipt;
  final Function(Receipt receiptParameter) saveTempReceipt,
      saveReceiptInJouerny;
  final bool isEnabled;
  final Function() addNewReceipt;
  const ExternalReceive(
      this.receipts, this.editReceiptInJouerny, this.receipt,
      {super.key,
      required this.saveTempReceipt,
      required this.saveReceiptInJouerny,
      required this.isEnabled,
      required this.addNewReceipt});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TaskList(receipts, editReceiptInJouerny),
        isEnabled
            ? ReceiptCard(
                receipt,
                false,
                parsedFunction: saveTempReceipt,
                saveReceiptInJouerny: saveReceiptInJouerny,
              )
            : const SizedBox(),
        const SizedBox(height: 30),
        CustomButton("اضف وصل", 250, addNewReceipt, isEnabled: !isEnabled),
      ],
    );
  }
}
