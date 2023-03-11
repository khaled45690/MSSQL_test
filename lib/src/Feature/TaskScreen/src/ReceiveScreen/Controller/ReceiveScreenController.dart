import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sql_test/DataTypes/CrewMember.dart';
import 'package:sql_test/DataTypes/Customer.dart';
import 'package:sql_test/DataTypes/CustomerBranch.dart';
import 'package:sql_test/StateManagement/UserData/UserData.dart';
import 'package:sql_test/Utilities/Extentions.dart';

import '../../../../../../DataTypes/User.dart';
import '../../../../../../MainWidgets/CustomButton.dart';
import '../../../../../../Utilities/Prefs.dart';
import '../../../../../../Utilities/Strings.dart';
import '../ReceiveScreen.dart';

abstract class ReceiveScreenController extends State<ReceiveScreen> {
  MobileScannerController cameraController =
      MobileScannerController(facing: CameraFacing.back);
  double height = 0;
  bool isAddingEmployee = false,
      isSearchingForEmploy = false,
      canWeAddMoreEmp = true,
      isCustomerSelected = false;
  String empIdFromTextField = "";
  List<Customer> customerList = [];
  List<CustomerBranch> customerBranchList = [];

  @override
  void initState() {
    super.initState();
    _setCustomerList();
    _setCrewMembers();
    _setCustomerBranches();
    _stopCameraAtStart();
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

  onCapture(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    final Uint8List? image = capture.image;
    for (final barcode in barcodes) {
      debugPrint('Barcode found! ${barcode.rawValue}');
      if (barcode.rawValue == null) return;
      return _addEmpByCam(barcode.rawValue!, true);
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

  addEmpByTextFunc() {
    _addEmpByCam(empIdFromTextField, false);
  }

  onSelectCustomerFunc(Customer customer) {
    widget.receipt.F_Cust = customer;
    isCustomerSelected = true;
    widget.parsedFunction(widget.receipt);
    customerBranchList = customer.CustomerBranches;
    setState(() {});
  }

  onSelectCustomerBranchFunc(CustomerBranch customerBranch) {
    widget.receipt.F_Branch_Internal_D = customerBranch.F_Branch_Internal;
    widget.receipt.F_Branch_D = customerBranch;
    widget.parsedFunction(widget.receipt);
    setState(() {});
  }

  removeEMp(int empId) {
    List<CrewMember> filter = [];
    for (var crewMember in widget.receipt.CrewIdList) {
      if (crewMember.F_EmpID != empId) {
        filter.add(crewMember);
      }
    }

    widget.receipt.CrewIdList = filter;
    widget.parsedFunction(widget.receipt);
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
    List<User> allUsers = User.fromJsonStringListToUserList(
        Prefs.getString(allUsersFromLocaleDataBase)!);
    debugPrint(Prefs.getString(allUsersFromLocaleDataBase)!);
    for (User user in allUsers) {
      if (user.F_EmpID == empId) {
        bool doesThisEmpAddedBefore = false;
        for (CrewMember crewMember in widget.receipt.CrewIdList) {
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
          content: Text(addingEmpAlertDialogBody(user.F_EmpName),
              textDirection: TextDirection.rtl),
          actions: <Widget>[
            TextButton(
              child: const Text(confirm),
              onPressed: () {
                CrewMember crewMember = CrewMember(
                    F_EmpID: user.F_EmpID, F_EmpName: user.F_EmpName);
                widget.receipt.CrewIdList.add(crewMember);
                widget.parsedFunction(widget.receipt);
                if (!isCam) isAddingEmployee = false;
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
    if (widget.receipt.CrewIdList.length >= 6) {
      if (cameraController.isStarting) stopQRDetection();
      Timer(const Duration(milliseconds: 700), () {
        canWeAddMoreEmp = false;
        setState(() {});
      });
    }
  }

  _setCustomerList() {
    String? customerListString = Prefs.getString(customersInfo);
    if (customerListString != null) {
      customerList =
          Customer.fromJsonStringListToCustomerList(customerListString);
    }
  }

  _setCustomerBranches() {
    if (widget.receipt.F_Cust != null) {
      isCustomerSelected = true;
      customerBranchList = widget.receipt.F_Cust!.CustomerBranches;
    }
  }

  _setCrewMembers() {
    User userData = context.read<UserCubit>().state!;
    CrewMember crewLeader =
        CrewMember(F_EmpID: userData.F_EmpID, F_EmpName: userData.F_EmpName);

    if (widget.receipt.CrewIdList.isEmpty) {
      widget.receipt.CrewIdList.add(crewLeader);
      widget.parsedFunction(widget.receipt);
    }
  }

  _stopCameraAtStart() {
    Timer(const Duration(milliseconds: 500), () => {cameraController.stop()});
  }
}
