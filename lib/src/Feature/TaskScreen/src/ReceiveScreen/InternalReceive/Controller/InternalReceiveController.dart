// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sql_conn/sql_conn.dart';
import 'package:sql_test/src/StateManagement/UserData/UserData.dart';
import 'package:sql_test/src/Utilities/Extentions.dart';

import '../../../../../../DataTypes/CrewMember.dart';
import '../../../../../../DataTypes/Journey.dart';
import '../../../../../../DataTypes/Receipt.dart';
import '../../../../../../DataTypes/ReceiptDetails.dart';
import '../../../../../../DataTypes/User.dart';
import '../../../../../../MainWidgets/CustomButton.dart';
import '../../../../../../StateManagement/JourneyData/JourneyData.dart';
import '../../../../../../Utilities/Prefs.dart';
import '../../../../../../Utilities/Strings.dart';
import '../../../../../../Utilities/VariableCodes.dart';
import '../InternalRecieve.dart';
import '../Model/ReceiptInternalReceiveData.dart';
import '../Model/TransferReceipt.dart';

abstract class InternalReceiveController extends State<InternalReceive> {
  double height = 0;
  bool isAddingEmployee = false, isLoading = false, isSearchingForEmploy = false, canWeAddMoreEmp = true, isCustomerSelected = false, isCustomerRSelected = false;
  MobileScannerController cameraController = MobileScannerController(facing: CameraFacing.back);
  TextEditingController empTextFilledAdder = TextEditingController();
  ReceiptInternalReceiveData receiptInternalReceiveData = ReceiptInternalReceiveData.fromJson({});
  List<TransferReceipt> selectedTransferReceiptList = [], transferReceiptList = [], transferReceiptFilterList = [];
  String empIdFromTextField = "";

  @override
  void initState() {
    super.initState();
    _getInternalReciept();
    _setCrewMembers();
    _stopCameraAtStart();
  }

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
      case "AddNote":
        receiptInternalReceiveData.note = value;
        break;
      default:
    }
    setState(() {});
  }

  onSelectReceiptFunc(TransferReceipt tansferReceipt) {
    selectedTransferReceiptList.add(tansferReceipt);
    _receiptFilteredFunc(tansferReceipt);
    setState(() {});
  }

  removeReceiptDeliver(int index) {
    List<TransferReceipt> filter = [];
    for (int i = 0; i < selectedTransferReceiptList.length; i++) {
      if (i != index) {
        filter.add(selectedTransferReceiptList[i]);
      } else {
        transferReceiptFilterList.add(transferReceiptList[i]);
      }
    }
    selectedTransferReceiptList = filter;
    setState(() {});
  }

  receiveReceipts() {
    isLoading = true;
    setState(() {});
    if (_checkSelectedTransferReceipt()) return;
    _getRecieptDetailsAndSaveThemLocaly();

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

  _getInternalReciept() async {
    String query = _getInternalRecieptQuery(context.read<UserCubit>().state!.F_EmpID);
    String recieptDetailsString = await SqlConn.readData(query);
    transferReceiptList = TransferReceipt.fromJsonStringListToTransferReceiptList(recieptDetailsString);
    transferReceiptFilterList = transferReceiptList;
  }

  _setCrewMembers() {
    if (widget.receipts.isEmpty) return receiptInternalReceiveData.CrewIdList = [CrewMember(F_EmpID: context.read<UserCubit>().state!.F_EmpID, F_EmpName: context.read<UserCubit>().state!.F_EmpName)];
    receiptInternalReceiveData.CrewIdList = widget.receipts[widget.receipts.length - 1].CrewIdList;
  }

  bool _checkSelectedTransferReceipt() {
    bool isTrue = false;

    if (selectedTransferReceiptList.isEmpty) {
      isTrue = false;
      context.snackBar(transferReceiptIsNotSelected, color: Colors.red);
      isLoading = false;
      setState(() {});
    }
    return isTrue;
  }

  _getRecieptDetailsAndSaveThemLocaly() async {
    String query = _getQueryToUpdateTransferTable(selectedTransferReceiptList, context.read<UserCubit>().state!.F_EmpID);

    try {
      List<Receipt> receipts = [];
      for (TransferReceipt transferReceipt in selectedTransferReceiptList) {
        await SqlConn.writeData(query);
        String recieptDetailsListString = await SqlConn.readData("SELECT * from dbo.T_Deliver_Recieve_M WHERE F_Recipt_No = ${transferReceipt.F_Recipt_No} ");
        receipts = Receipt.fromJsonStringListToReceiptList(recieptDetailsListString, isUpdatingFromDatabase: true);
        for (var i = 0; i < receipts.length; i++) {
          String recieptsDetailsDataString = await SqlConn.readData("SELECT * from dbo.T_Deliver_Recieve_D WHERE F_Recipt_No = ${receipts[i].F_Recipt_No}");
          receipts[i].ReceiptDetailsList = ReceiptDetails.fromJsonStringListToReceiptDetailsList(recieptsDetailsDataString);
          receipts[i].isSavedInDatabase = true;
        }
      }

      Journey dumyJoureny = context.read<JourneyCubit>().state[context.read<JourneyCubit>().state.length - 1];
      dumyJoureny.receiptList.addAll(receipts);
      context.read<JourneyCubit>().setjourneyDataWithSharedPrefrence([dumyJoureny]);

      context.snackBar(dataHasBeenUpdated, color: Colors.green.shade900);

      Timer(const Duration(milliseconds: 600), context.popupAllUntill("/JourneyScreen"));
    } catch (e) {
      context.snackBar(dataHasNotBeenUpdated, color: Colors.red.shade900);
    }
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

  void _receiptFilteredFunc(TransferReceipt receiptDeliver) {
    List<TransferReceipt> filter = [];
    for (int i = 0; i < transferReceiptFilterList.length; i++) {
      if (transferReceiptFilterList[i].F_Recipt_No != receiptDeliver.F_Recipt_No) {
        filter.add(transferReceiptFilterList[i]);
      }
    }
    transferReceiptFilterList = filter;
    setState(() {});
  }

  String _getInternalRecieptQuery(int empId) {
    return ' SELECT dbo.T_Transfer.F_Trans_Id, dbo.T_Transfer.Post_Status, dbo.T_Transfer.F_Recipt_No, dbo.T_Deliver_Recieve_M.F_Paper_No'
        ' FROM dbo.T_Deliver_Recieve_M INNER JOIN '
        'dbo.T_Transfer ON dbo.T_Deliver_Recieve_M.F_Recipt_No = dbo.T_Transfer.F_Recipt_No WHERE dbo.T_Transfer.Post_Status = 0 AND (dbo.T_Transfer.UserID_Recived_ID = $empId OR dbo.T_Transfer.UserID_Trans_ID = $empId )';

    // Select * From dbo.Transfer_View WHERE F_Emp_Id = ${user!.F_EmpID} ORDER BY F_Id ASC
  }

  String _getQueryToUpdateTransferTable(List<TransferReceipt> selectedTransferReceiptList, int empID) {
    String updateQuery = "";
    String crewList = _updateCrewMemberQuery(receiptInternalReceiveData.CrewIdList);
    for (TransferReceipt selectedTransferReceipt in selectedTransferReceiptList) {
      updateQuery += " UPDATE dbo.T_Transfer "
          " SET Post_Status = 1,"
          "UserID_Recived_ID = $empID,"
          "F_Note_Recived = '${receiptInternalReceiveData.note}' ,"
          "Date_Recived =  CAST( '${DateTime.now()}' AS DATETIME2),"
          "Time_Recived = CAST( '${DateTime.now()}' AS DATETIME2),"
          "$crewList "
          " WHERE F_Trans_Id = ${selectedTransferReceipt.F_Trans_Id};";
    }
    return updateQuery;
  }

  _updateCrewMemberQuery(List<CrewMember> crewList) {
    String crewListQuery = "";

    for (int x = 0; x < crewList.length; x++) {
      crewListQuery += "F_Team${x + 1}_R = ${crewList[x].F_EmpID}";
      if (x < crewList.length - 1) {
        crewListQuery += ",";
      }
    }

    return crewListQuery;
  }
   _stopCameraAtStart() {
    Timer(const Duration(milliseconds: 800), () => cameraController.stop());
  }

}
