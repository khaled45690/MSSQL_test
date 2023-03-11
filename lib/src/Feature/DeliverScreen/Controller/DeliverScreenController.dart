import 'dart:async';

import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../MainWidgets/CustomButton.dart';
import '../../../../MainWidgets/SearchButtonSheetForCustomer.dart';
import '../DeliverScreen.dart';

abstract class DeliverScreenController extends State<DeliverScreen> {
  MobileScannerController cameraController =
      MobileScannerController(autoStart: false, facing: CameraFacing.back);
  bool isAddingEmployee = false;
  double height = 0;
  TimeOfDay _time = const TimeOfDay(hour: 5, minute: 24);

  startQRDetection() {
    cameraController.start();
    height = 200;
    isAddingEmployee = true;
    setState(() {});
  }

  stopQRDetection() {
    height = 0;
    Timer(const Duration(milliseconds: 300), () {
      cameraController.stop();
      isAddingEmployee = false;
      setState(() {});
    });
    setState(() {});
  }

  addChecks(BuildContext context) {
    // searchButtonSheet(context);
  }

  selectTime(BuildContext context) {
    Navigator.of(context).push(
      showPicker(
        context: context,
        value: _time,
        onChange: onTimeChanged,
      ),
    );
  }

// Widget Functions
  addingEmployeeButton() {
    if (isAddingEmployee)
      return CustomButton("توقف عن الاضافة", 200, stopQRDetection);
    return CustomButton("اضف الطاقم بالكاميرا", 200, startQRDetection);
  }

  onTimeChanged(TimeOfDay time) {
    _time = time;
    setState(() {});
  }
}
