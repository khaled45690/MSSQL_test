import 'package:flutter/material.dart';

import '../../../../StateManagement/JourneyData/Receipt.dart';
import '../TaskScreen.dart';

abstract class TaskScreenController extends State<TaskScreen> {
  String radioGroupValue = "Receive";
  static Receipt receipt = Receipt();
  onRadioChangeCallback(String radioGroupValue) {
    this.radioGroupValue = radioGroupValue;
    setState(() {});
  }


    static saveTempReceipt(Receipt receiptParameter) {
    receipt = receiptParameter;
  }
}
