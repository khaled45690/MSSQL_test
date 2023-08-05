// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sql_conn/sql_conn.dart';
import 'package:sql_test/src/Utilities/Extentions.dart';

import '../../../../../../../DataTypes/CrewMember.dart';
import '../../../../../../../DataTypes/Journey.dart';
import '../../../../../../../DataTypes/Receipt.dart';
import '../../../../../../../DataTypes/ReceiptDeliver.dart';
import '../../../../../../../DataTypes/User.dart';
import '../../../../../../../MainWidgets/CustomButton.dart';
import '../../../../../../../StateManagement/JourneyData/JourneyData.dart';
import '../../../../../../../StateManagement/UserData/UserData.dart';
import '../../../../../../../Utilities/Prefs.dart';
import '../../../../../../../Utilities/Strings.dart';
import '../InternalDeliverScreen.dart';
import '../Model/ReceiptInternalDeliverData.dart';

abstract class InternalDeliverScreenController extends State<InternalDeliverScreen> {
  MobileScannerController cameraController = MobileScannerController(facing: CameraFacing.back);
  List<ReceiptDeliver> receiptDeliverList = [];
  List<ReceiptDeliver> receiptFilteredDeliverList = [];
  ReceiptInternalDeliverData receiptInternalDeliverData = ReceiptInternalDeliverData.fromJson({});
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
    _setCrewlist();
        _stopCameraAtStart();
  }

  onSelectReceiptFunc(ReceiptDeliver receiptDeliver) {
    receiptInternalDeliverData.deliverReceipts.add(receiptDeliver);
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
    receiptInternalDeliverData.CrewIdList = [];
    isEmpReceiveIsNotAdded = true;
    setState(() {});
  }

  startQRDetection() {
    cameraController.start();
    height = 200;
    isAddingEmployee = true;
    if (_checkEmployerAdded()) return;
    isEmpReceiveIsNotAdded = false;
    setState(() {});
  }

  onTextChange(String variableName, String value) {
    switch (variableName) {
      case "AddEmpByText":
        empIdFromTextField = value;
        break;
      case "AddNote":
        receiptInternalDeliverData.note = value;
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
    for (int i = 0; i < receiptInternalDeliverData.deliverReceipts.length; i++) {
      if (i != index) {
        filter.add(receiptInternalDeliverData.deliverReceipts[i]);
      } else {
        receiptFilteredDeliverList.add(receiptInternalDeliverData.deliverReceipts[i]);
      }
    }
    receiptInternalDeliverData.deliverReceipts = filter;
    setState(() {});
  }

  deliverReceipts() async {
    try {
      isLoading = true;
      setState(() {});
      if (_checkInternetConnection()) return;
      if (_checkEmployerAdded()) return;
      if (_checkIsReceiptAdded()) return;

      await _submitDataToDatabase();
      isLoading = false;
      // Journey journey = context.read<JourneyCubit>().state[context.read<JourneyCubit>().state.length - 1];
      await _updateLocalDataBase();
      context.snackBar(receiptDeliverIsDeliverd, color: Colors.green.shade900);
      setState(() {});
    } catch (e) {
      context.snackBar(dataHasNotBeenUpdated, color: Colors.red.shade900);
    }
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

  _updateLocalDataBase() async {
    List<Receipt> receiptListFilter = [];
    Journey journey = widget.journey;
    for (Receipt receipt in journey.receiptList) {
      bool isNeedToBeAdded = true;
      for (ReceiptDeliver deliverReceipts in receiptInternalDeliverData.deliverReceipts) {
        if (receipt.F_Recipt_No == deliverReceipts.F_Recipt_No) {
          receipt.isDeliveredToAnotherDriver = true;
          isNeedToBeAdded = false;
          receiptListFilter.add(receipt);
        }
      }

      if (isNeedToBeAdded) receiptListFilter.add(receipt);
    }

    journey.receiptList = receiptListFilter;
    List<Journey> localJournies = context.read<JourneyCubit>().state;
    localJournies[localJournies.length - 1] = journey;
    context.read<JourneyCubit>().setjourneyDataWithSharedPrefrence(localJournies);
    context.popupAllUntill("/JourneyScreen");
  }

  bool _checkEmployerAdded() {
    bool isadded = false;
    if (!SqlConn.isConnected) {
      isLoading = false;
      setState(() {});
      context.snackBar(pleaseConnectToInternet, color: Colors.red);
      isadded = true;
    }

    return isadded;
  }

  bool _checkInternetConnection() {
    bool isadded = false;
    if (receiptInternalDeliverData.CrewIdList.isEmpty) {
      isLoading = false;
      setState(() {});
      context.snackBar(thisEmpDriverIsNotAdded, color: Colors.red);
      isadded = true;
    }

    return isadded;
  }

  bool _checkIsReceiptAdded() {
    bool isadded = false;
    if (receiptInternalDeliverData.deliverReceipts.isEmpty) {
      isLoading = false;
      setState(() {});
      context.snackBar(thisReceiptIsNotAdded, color: Colors.red);
      isadded = true;
    }

    return isadded;
  }

  _submitDataToDatabase() async {
    String query = _getQueryString();
    debugPrint(query, wrapWidth: 200);
    await SqlConn.writeData(query);
  }

  _getRecieptData() async {
    for (Receipt receipt in widget.journey.receiptList) {
      if (!receipt.isDeliveredToAnotherDriver) {
        receiptDeliverList.add(ReceiptDeliver.fromReceiptToReceiptDeliver(receipt));
      }
    }
    receiptFilteredDeliverList = receiptDeliverList;
    setState(() {});
  }

  String _getQueryString() {
    String queryString = '';
    int userEmpId = context.read<UserCubit>().state!.F_EmpID;
    Map<String, String> crewList = {};
    crewList = _insertCrewMemberQuery(widget.journey.receiptList[widget.journey.receiptList.length - 1].CrewIdList);
    for (ReceiptDeliver deliverReceipt in receiptInternalDeliverData.deliverReceipts) {
      queryString += "BEGIN TRANSACTION; DECLARE @F_Trans_Id INT;"
          "SELECT @F_Trans_Id = ISNULL(MAX(F_Trans_Id), 0) + 1 FROM dbo.T_Transfer;"
          "INSERT INTO dbo.T_Transfer (F_Trans_Id , F_Recipt_No , F_Date , F_Time , "
          "F_Note_Transmit , Post_Status , UserID_Trans_ID , UserID_Recived_ID, ${crewList["crewListQuery"]})"
          " VALUES (@F_Trans_Id, ${deliverReceipt.F_Recipt_No}, CAST('${DateTime.now()} ' AS DATETIME2), CAST('${DateTime.now()} ' AS DATETIME2), "
          "'${receiptInternalDeliverData.note}' , 0 , $userEmpId , ${receiptInternalDeliverData.CrewIdList[0].F_EmpID}, ${crewList["crewListValues"]});";
    }

    queryString += "COMMIT TRANSACTION";
    return queryString;
  }

  _insertCrewMemberQuery(List<CrewMember> crewList) {
    String crewListQuery = "";
    String crewListValues = "";

    for (int x = 0; x < crewList.length; x++) {
      crewListQuery += "F_Team${x + 1}";
      crewListValues += "${crewList[x].F_EmpID}";
      if (x < crewList.length - 1) {
        crewListQuery += ",";
        crewListValues += ",";
      }
    }

    return {"crewListQuery": crewListQuery, "crewListValues": crewListValues};
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
        } else if (user.F_EmpID == context.read<UserCubit>().state!.F_EmpID) {
          return setState(() {
            if (!isCam) isAddingEmployee = false;
            if (isCam) cameraController.start();
            context.snackBar(thisIsTheAccountUser, color: Colors.red);
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
                receiptInternalDeliverData.CrewIdList.add(crewMember);
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

  _setCrewlist() {
    User userData = context.read<UserCubit>().state!;
    CrewMember crewLeader = CrewMember(F_EmpID: userData.F_EmpID, F_EmpName: userData.F_EmpName);

    if (widget.journey.receiptList.isEmpty) {
      receiptInternalDeliverData.CrewIdList.add(crewLeader);
    } else {
      receiptInternalDeliverData.CrewIdList = widget.journey.receiptList[widget.journey.receiptList.length - 1].CrewIdList;
    }

    setState(() {});
  }
   _stopCameraAtStart() {
    Timer(const Duration(milliseconds: 500), () => cameraController.stop());
  }

}
