import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sql_test/StateManagement/JourneyData/Receipt.dart';

import '../../../../../../MainWidgets/CustomButton.dart';
import '../../../Controller/TaskScreenController.dart';
import '../ReceiveScreen.dart';

abstract class ReceiveScreenController extends State<ReceiveScreen> {
  MobileScannerController cameraController =
      MobileScannerController(autoStart: false, facing: CameraFacing.back);
  double height = 0;
  bool isAddingEmployee = false;
  late Receipt receipt;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    receipt = TaskScreenController.receipt;
  }

  addingEmployeeButton() {
    if (isAddingEmployee) return CustomButton("توقف عن الاضافة", 200, stopQRDetection);
    return CustomButton("اضف الطاقم بالكاميرا", 200, startQRDetection);
  }

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
}
