import 'package:flutter/material.dart';
import 'package:sql_test/Utilities/Extentions.dart';
import 'package:sql_test/src/Feature/TaskScreen/Widgets/ReceiptCard.dart';

import '../../../../DataTypes/Receipt.dart';

class TaskList extends StatelessWidget {
  final List<Receipt> receipts;
  final Function(Receipt receiptParameter , int receiptIndex) parsedFunction;
  const TaskList(this.receipts, this.parsedFunction,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width() - 40,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: receipts.length,
        itemBuilder: (BuildContext context, int i) {
          return ReceiptCard(
            receipts[i],
            true,
            parsedFunction: (receipt) => parsedFunction(receipt , i),
            saveReceiptInJouerny: (receipt) => parsedFunction(receipt , i),
          );
        },
      ),
    );
  }
}
