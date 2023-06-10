// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sql_test/src/Utilities/Extentions.dart';

import '../../../../../../DataTypes/CrewMember.dart';
import '../../../../../../DataTypes/ReceiptDeliver.dart';
import '../../../../../../DataTypes/User.dart';
import '../../../../../../MainWidgets/CustomButton.dart';
import '../../../../../../Utilities/Prefs.dart';
import '../../../../../../Utilities/Strings.dart';
import '../../../../../../Utilities/VariableCodes.dart';
import '../InternalRecieve.dart';
import '../Model/ReceiptInternalReceiveData.dart';

abstract class InternalReceiveController extends State<InternalReceive> {
  double height = 0;
  bool isAddingEmployee = false, isLoading = false ,isSearchingForEmploy = false, canWeAddMoreEmp = true, isCustomerSelected = false, isCustomerRSelected = false;
  MobileScannerController cameraController = MobileScannerController(facing: CameraFacing.back);
  TextEditingController empTextFilledAdder = TextEditingController();
  ReceiptInternalReceiveData receiptInternalReceiveData = ReceiptInternalReceiveData.fromJson({});
  List<ReceiptDeliver> receiptDeliverList = [] , receiptFilteredDeliverList = [];
  String empIdFromTextField = "";
  onCapture(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      debugPrint('Barcode found! ${barcode.rawValue}');
      if (barcode.rawValue == null) return;
      return _addEmpByCam(barcode.rawValue!, true);
    }
  }

  addingEmployeeButton() {
    if (isAddingEmployee) {
      return CustomButton("توقف عن الاضافة", 200, stopQRDetection);
    }
    return CustomButton(
      "اضف الطاقم بالكاميرا",
      200,
      startQRDetection,
      isEnabled: canWeAddMoreEmp,
    );
  }

  startQRDetection() {
    cameraController.start();
    height = 200;
    isAddingEmployee = true;
    canWeAddMoreEmp = false;
    setState(() {});
  }

  stopQRDetection() {
    height = 0;
    Timer(const Duration(milliseconds: 300), () {
      cameraController.stop();
      isAddingEmployee = false;
      canWeAddMoreEmp = true;
      setState(() {});
    });
    setState(() {});
  }

  addEmpByTextFunc() {
    _addEmpByCam(empIdFromTextField, false);
  }

  removeEMp(int empId) {
    List<CrewMember> filter = [];
    for (CrewMember crewMember in receiptInternalReceiveData.CrewIdList) {
      if (crewMember.F_EmpID != empId) {
        filter.add(crewMember);
      }
    }
  }

  onTextChange(String variableName, String value) {
    switch (variableName) {
      case "AddEmpByText":
        empIdFromTextField = value;
        break;
      default:
    }
    setState(() {});
  }
  onSelectReceiptFunc(ReceiptDeliver receiptDeliver) {
    receiptInternalReceiveData.deliverReceipts.add(receiptDeliver);
    _receiptFilteredFunc(receiptDeliver);
    setState(() {});
  }

    removeReceiptDeliver(int index) {
    List<ReceiptDeliver> filter = [];
    for (int i = 0; i < receiptInternalReceiveData.deliverReceipts.length; i++) {
      if (i != index) {
        filter.add(receiptInternalReceiveData.deliverReceipts[i]);
      } else {
        receiptFilteredDeliverList.add(receiptInternalReceiveData.deliverReceipts[i]);
      }
    }
    receiptInternalReceiveData.deliverReceipts = filter;
    setState(() {});
  }
  receiveReceipts() {
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
        bool doesThisEmpAddedBefore = false;
        for (CrewMember crewMember in receiptInternalReceiveData.CrewIdList) {
          if (crewMember.F_EmpID == empId) doesThisEmpAddedBefore = true;
        }
        if (doesThisEmpAddedBefore) {
          return setState(() {
            if (!isCam) isAddingEmployee = false;
            if (isCam) cameraController.start();
            if (!isCam) {
              context.snackBar(thisEmpIsAddedBefore, color: Colors.red);
            }
          });
        }
        _showMyDialog(user, isCam);
        return;
      }
    }
    if (isCam) cameraController.start();
    if (!isCam) isAddingEmployee = false;
    if (!isCam) context.snackBar(cantFindEmp, color: Colors.red);
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
                receiptInternalReceiveData.CrewIdList.add(crewMember);
                if (!isCam) isAddingEmployee = false;
                if (!isCam) empTextFilledAdder.text = '';
                setState(() {});
                if (isCam) cameraController.start();
                Navigator.of(context).pop();
                _checkIfCrewAreSix();
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

  _checkIfCrewAreSix() {
    if (receiptInternalReceiveData.CrewIdList.length >= maxEmpSize) {
      if (cameraController.isStarting) stopQRDetection();
      Timer(const Duration(milliseconds: 700), () {
        canWeAddMoreEmp = false;
        setState(() {});
      });
    }
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
}
