// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sql_test/src/Utilities/Extentions.dart';

import '../../../../../../../DataTypes/CrewMember.dart';
import '../../../../../../../DataTypes/ReceiptDeliver.dart';
import '../../../../../../../DataTypes/ReceiptDeliverData.dart';
import '../../../../../../../DataTypes/User.dart';
import '../../../../../../../MainWidgets/CustomButton.dart';
import '../../../../../../../Utilities/Prefs.dart';
import '../../../../../../../Utilities/Strings.dart';
import '../InternalDeliverScreen.dart';

abstract class InternalDeliverScreenController extends State<InternalDeliverScreen> {
  MobileScannerController cameraController = MobileScannerController(facing: CameraFacing.back);
  List<ReceiptDeliver> receiptDeliverList = [];
  List<ReceiptDeliver> receiptFilteredDeliverList = [];
  ReceiptDeliverData receiptDeliverData = ReceiptDeliverData.fromJson({});
  bool isAddingEmployee = false, isLoading = false, isSearchingForEmploy = false, isEmpReceiveIsNotAdded = true;
  TextEditingController empTextFilledAdder = TextEditingController();
  String empIdFromTextField = "";
  double height = 0;

  addEmpByTextFunc() {
    _addEmpByCam(empIdFromTextField, false);
  }

  @override
  void initState() {
    super.initState();
    _getRecieptData();
  }

  onSelectReceiptFunc(ReceiptDeliver receiptDeliver) {
    receiptDeliverData.deliverReceipts.add(receiptDeliver);
    _receiptFilteredFunc(receiptDeliver);
    setState(() {});
  }

  addingEmployeeButton() {
    if (isAddingEmployee) {
      return CustomButton("توقف عن الاضافة", 200, stopQRDetection);
    }
    return CustomButton(
      "اضف الطاقم بالكاميرا",
      200,
      startQRDetection,
      isEnabled: isEmpReceiveIsNotAdded,
    );
  }

  removeEMp(int empId) {
    receiptDeliverData.CrewIdList = [];
    isEmpReceiveIsNotAdded = true;
    setState(() {});
  }

  startQRDetection() {
    cameraController.start();
    height = 200;
    isAddingEmployee = true;
    isEmpReceiveIsNotAdded = false;
    setState(() {});
  }

  onTextChange(String variableName, String value) {
    switch (variableName) {
      case "AddEmpByText":
        empIdFromTextField = value;
        break;
      case "AddNote":
        empIdFromTextField = value;
        break;
      default:
    }
    setState(() {});
  }

  stopQRDetection() {
    height = 0;
    Timer(const Duration(milliseconds: 300), () {
      cameraController.stop();
      isAddingEmployee = false;
      isEmpReceiveIsNotAdded = true;
      setState(() {});
    });
    setState(() {});
  }

  onCapture(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      debugPrint('Barcode found! ${barcode.rawValue}');
      if (barcode.rawValue == null) return;
      return _addEmpByCam(barcode.rawValue!, true);
    }
  }

  removeReceiptDeliver(int index) {
    List<ReceiptDeliver> filter = [];
    for (int i = 0; i < receiptDeliverData.deliverReceipts.length; i++) {
      if (i != index) {
        filter.add(receiptDeliverData.deliverReceipts[i]);
      } else {
        receiptFilteredDeliverList.add(receiptDeliverData.deliverReceipts[i]);
      }
    }
    receiptDeliverData.deliverReceipts = filter;
    setState(() {});
  }

  deliverReceipts() {
    isLoading = true;
    setState(() {});

    isLoading = false;
    setState(() {});
  }

  ///////////////////////////////////////////////////////////////////////////
  //                                                                       //
  //                                                                       //
  //                                                                       //
  //  the seperator between the Main function and their helpers functions  //
  //                                                                       //
  //                                                                       //
  //                                                                       //
  ///////////////////////////////////////////////////////////////////////////

  _getRecieptData() async {
    receiptDeliverList = ReceiptDeliver.fromReceiptListToReceiptDeliverList(widget.journey.receiptList);
    receiptFilteredDeliverList = receiptDeliverList;
    setState(() {});
  }

  void _receiptFilteredFunc(ReceiptDeliver receiptDeliver) {
    List<ReceiptDeliver> filter = [];
    for (int i = 0; i < receiptFilteredDeliverList.length; i++) {
      if (receiptFilteredDeliverList[i].F_Recipt_No != receiptDeliver.F_Recipt_No) {
        filter.add(receiptFilteredDeliverList[i]);
      }
    }
    receiptFilteredDeliverList = filter;
    setState(() {});
  }

  _addEmpByCam(String empIdString, bool isCam) {
    isAddingEmployee = true;
    if (isCam) cameraController.stop();
    setState(() {});
    int? empId = int.tryParse(empIdString);
    if (empId == null) {
      return setState(() {
        if (!isCam) isAddingEmployee = false;
        if (isCam) cameraController.start();
      });
    }
    List<User> allUsers = User.fromJsonStringListToUserList(Prefs.getString(allUsersFromLocaleDataBase)!);
    for (User user in allUsers) {
      if (user.F_EmpID == empId) {
        if (user.F_Prevlage != 3) {
          return setState(() {
            if (!isCam) isAddingEmployee = false;
            if (isCam) cameraController.start();
            context.snackBar(thisEmpIsNotDriver, color: Colors.red);
          });
        }
        _showMyDialog(user, isCam);
        return;
      }
    }
    setState(() {});
  }

  Future<void> _showMyDialog(User user, bool isCam) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            addingEmpAlertDialogTitle,
            textDirection: TextDirection.rtl,
          ),
          content: Text(addingEmpAlertDialogBody(user.F_EmpName), textDirection: TextDirection.rtl),
          actions: <Widget>[
            TextButton(
              child: const Text(confirm),
              onPressed: () {
                CrewMember crewMember = CrewMember(F_EmpID: user.F_EmpID, F_EmpName: user.F_EmpName);
                receiptDeliverData.CrewIdList.add(crewMember);
                if (!isCam) isAddingEmployee = false;
                if (!isCam) empTextFilledAdder.text = '';
                setState(() {});
                if (isCam) cameraController.start();
                stopQRDetection();
                Timer(const Duration(milliseconds: 400), () {
                  isEmpReceiveIsNotAdded = false;
                  setState(() {});
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(refuse),
              onPressed: () {
                if (!isCam) isAddingEmployee = false;
                if (!isCam) empTextFilledAdder.text = '';
                setState(() {});
                if (isCam) cameraController.start();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
