import 'package:flutter/material.dart';
import 'package:sql_test/Utilities/Extentions.dart';
import 'package:sql_test/src/Feature/TaskScreen/Widgets/ReceiptCard.dart';

import '../../../../DataTypes/Receipt.dart';

class TaskList extends StatelessWidget {
  final List<Receipt> reciepts;
  final Function(Receipt receiptParameter) parsedFunction;
  const TaskList(this.reciepts, this.parsedFunction ,{super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width() - 40,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: reciepts.length,
        itemBuilder: (BuildContext context, int i) {
          return ReceiptCard(reciepts[i], true ,parsedFunction: parsedFunction,);
        },
      ),
    );
  }
}
