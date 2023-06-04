// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sql_test/src/DataTypes/Journey.dart';
import 'package:sql_test/src/Utilities/Extentions.dart';
import 'package:sql_test/src/Feature/TaskScreen/src/DeliverTaskScreen/DeliverTaskScreen.dart';
import '../../Utilities/Colors.dart';
import '../../Utilities/VariableCodes.dart';
import 'Controller/TaskScreenController.dart';
import 'Widgets/InternalAndExternalReceiveRadioButton.dart';
import 'Widgets/ReceiveAndDeliverRadioGroup.dart';
import 'src/ReceiveScreen/ExternalReceive/ExternalReceive.dart';
import 'src/ReceiveScreen/InternalReceive/InternalRecieve.dart';
import 'src/ReceiveScreen/ReceiveScreen.dart';

class TaskScreen extends StatefulWidget {
  final Journey journey;
  final Function() updateDataBase;
  const TaskScreen(this.journey, this.updateDataBase, {super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends TaskScreenController {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: mainBlue),
      body: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SizedBox(
            width: context.width(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                ReceiveAndDeliverRadioGroup(
                    radioGroupValue: radioGroupValue,
                    onRadioChangeCallback: onRadioChangeCallback),
                const SizedBox(height: 10),
                radioGroupValue == "Receive"
                    ? ReceiveScreen(
                        receipts: widget.journey.receiptList,
                        editReceiptInJouerny: editReceiptInJouerny,
                        receipt: receipt,
                        saveTempReceipt: saveTempReceipt,
                        saveReceiptInJouerny: saveReceiptInJouerny,
                        isAddingNewReceipt: isAddingNewReceipt,
                        addNewReceipt: addNewReceipt,
                        receiveradioGroupValue: receiveradioGroupValue,
                        receiveOnRadioChangeCallback:
                            receiveOnRadioChangeCallback)
                    : DeliverTaskScreen(widget.journey, deliveryradioGroupValue,
                        deliveryOnRadioChangeCallback),
                // Column(
                //   children: [
                //     TaskList(widget.journey.receiptList, editReceiptInJouerny),
                //     isAddingNewReceipt
                //         ? ReceiptCard(
                //             receipt,
                //             false,
                //             parsedFunction: saveTempReceipt,
                //             saveReceiptInJouerny: saveReceiptInJouerny,
                //           )
                //         : const SizedBox(),
                //     const SizedBox(height: 30),
                //     CustomButton("اضف وصل", 250, addNewReceipt,
                //         isEnabled: !isAddingNewReceipt),
                //   ],
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
