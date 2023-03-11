import 'package:flutter/material.dart';

import '../../../../DataTypes/Receipt.dart';
import '../TaskScreen.dart';

abstract class TaskScreenController extends State<TaskScreen> {
  String radioGroupValue = "Receive";
  Receipt receipt = Receipt();
  bool isAddingNewReceipt = false;
  onRadioChangeCallback(String radioGroupValue) {
    this.radioGroupValue = radioGroupValue;
    setState(() {});
  }

   saveTempReceipt(Receipt receiptParameter) {
    receipt = receiptParameter;
  }

  addNewReceipt() {
    isAddingNewReceipt = true;
    setState(() {});
  }
}
