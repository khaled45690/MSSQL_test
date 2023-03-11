import 'package:flutter/material.dart';
import 'package:sql_test/DataTypes/Journey.dart';
import 'package:sql_test/Utilities/Extentions.dart';

import '../../../MainWidgets/CustomButton.dart';
import '../../../Utilities/Colors.dart';
import 'Controller/TaskScreenController.dart';
import 'Widgets/ReceiveAndDeliverRadioGroup.dart';
import 'Widgets/ReceiptCard.dart';
import 'Widgets/TaskList.dart';

class TaskScreen extends StatefulWidget {
  final Journey journey;
  const TaskScreen(this.journey, {super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends TaskScreenController {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: mainBlue),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          width: context.width(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              ReceiveAndDeliverRadioGroup(
                  radioGroupValue: radioGroupValue,
                  onRadioChangeCallback: onRadioChangeCallback),
              const SizedBox(height: 30),
              TaskList(widget.journey.receiptList , saveTempReceipt),
              isAddingNewReceipt
                  ? ReceiptCard(receipt, false , parsedFunction: saveTempReceipt)
                  : const SizedBox(),
              const SizedBox(height: 30),
              CustomButton("اضف وصل", 250, addNewReceipt,
                  isEnabled: !isAddingNewReceipt),
            ],
          ),
        ),
      ),
    );
  }
}
