// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:async';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sql_conn/sql_conn.dart';
import 'package:sql_test/DataTypes/CustomerBranch.dart';
import 'package:sql_test/Utilities/Extentions.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../../../../DataTypes/CrewMember.dart';
import '../../../../../../DataTypes/Customer.dart';
import '../../../../../../DataTypes/ReceiptDeliver.dart';
import '../../../../../../DataTypes/ReceiptDeliverData.dart';
import '../../../../../../DataTypes/User.dart';
import '../../../../../../MainWidgets/CustomButton.dart';
import '../../../../../../StateManagement/InternetState/InternetStateHandler.dart';
import '../../../../../../StateManagement/UserData/UserData.dart';
import '../../../../../../Utilities/Prefs.dart';
import '../../../../../../Utilities/Strings.dart';
import '../DeliverTaskScreen.dart';

abstract class DeliverTaskController extends State<DeliverTaskScreen> {
  Customer? customerR;
  CustomerBranch? customerBranchR;
  List<Customer> customerList = [];
  ReceiptDeliverData receiptDeliverData = ReceiptDeliverData.fromJson({});
  bool isCustomerRSelected = false;
  List<CustomerBranch> customerBranchListR = [];
  List<ReceiptDeliver> receiptDeliverList = [];
  String empIdFromTextField = "";
  List<Uint8List> receiptImageList = [];
  final ImagePicker _picker = ImagePicker();
  MobileScannerController cameraController =
      MobileScannerController(facing: CameraFacing.back);
  bool isAddingEmployee = false,
      isSearchingForEmploy = false,
      canWeAddMoreEmp = true;
  double height = 0;
  StreamSubscription<bool>? internetConnectionListenerForRetrevingData;
  StreamSubscription<bool>? internetConnectionListener;
  @override
  void initState() {
    super.initState();
    _setCustomerList();
    _setCrewlist();
  }

  @override
  void dispose() {
    super.dispose();
    if (internetConnectionListenerForRetrevingData != null)
      internetConnectionListenerForRetrevingData!.cancel();
    if (internetConnectionListener != null)
      internetConnectionListener!.cancel();
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

  onSelectCustomerFunc(Customer customer, bool isDeliveredTo) {
    customerR = customer;
    customerBranchListR = customer.CustomerBranches;
    isCustomerRSelected = true;
    setState(() {});
  }

  removeEMp(int empId) {
    List<CrewMember> filter = [];
    for (var crewMember in receiptDeliverData.CrewIdList) {
      if (crewMember.F_EmpID != empId) {
        filter.add(crewMember);
      }
    }

    receiptDeliverData.CrewIdList = filter;
    setState(() {});
  }

  removeReceiptDeliver(int index) {
    List<ReceiptDeliver> filter = [];
    for (int i = 0; i < receiptDeliverData.deliverReceipts.length; i++) {
      if (i != index) {
        filter.add(receiptDeliverData.deliverReceipts[index]);
      }
    }
    receiptDeliverData.deliverReceipts = filter;
    setState(() {});
  }

  onSelectCustomerBranchFunc(
      CustomerBranch customerBranch, bool isDeliveredTo) {
    customerBranchR = customerBranch;
    if (!_sqlConnectionChecker()) {
      internetConnectionListenerForRetrevingData = InternetConnectionCubit
          .isConnectedToInternet.stream
          .listen(_internetConnectionListenerForRetrevingData);
      return context.snackBar(pleaseConnectToInternet,
          color: Colors.red.shade900);
    }
    _getRecieptData();
    setState(() {});
  }

  onSelectReceiptFunc(ReceiptDeliver receiptDeliver) {
    receiptDeliverData.deliverReceipts.add(receiptDeliver);
    _getRecieptData();
    setState(() {});
  }

  pickDate(bool isArriveTime) async {
    Navigator.of(context).push(showPicker(
      context: context,
      value: Time(hour: DateTime.now().hour, minute: DateTime.now().minute),
      onChange: (onTimeChanged) => _onTimeSelected(onTimeChanged, isArriveTime),
    ));
  }

  takeReciptPicture() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
      maxHeight: 600,
    );
    if (pickedFile == null) return;

    Uint8List readAsString = await pickedFile.readAsBytes();

    receiptImageList.add(readAsString);

    setState(() {});
  }

  removeReciptPicture(int imageIndex) {
    List<Uint8List> filter = [];
    for (var i = 0; i < receiptImageList.length; i++) {
      if (i != imageIndex) {
        filter.add(receiptImageList[i]);
      } else if (i == imageIndex) {}
    }

    receiptImageList = filter;
    setState(() {});
  }

  submittingReceipts() {
    if (_missingDataCheck()) return;
    if (_missingImageCheck()) return;
    if (_notConnectedToDatabase()) return;

    _saveReceiptDeliver();
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

  _saveReceiptDeliver() async {
    receiptDeliverData.Time_Edit = DateTime.now().toString();
    receiptDeliverData.Date_Edit = DateTime.now().toString();
    receiptDeliverData.F_Id_R = widget.journey.F_Id;
    receiptDeliverData.Userid_Edit_ID = widget.journey.F_Emp_Id.toString();
    receiptDeliverData.pdfImages = await _convertImagesToPDF();
    String crewList = _updateCrewMemberQuery(receiptDeliverData.CrewIdList);
    String receiptDeliverQuery =
        _updateReceiptQuery(receiptDeliverData.deliverReceipts);
    var pdfInHexFormate = hex.encode(receiptDeliverData.pdfImages!.toList());
    String query = " UPDATE dbo.T_Deliver_Recieve_M"
        " SET Userid_Edit_ID = ${receiptDeliverData.Userid_Edit_ID} , Date_Edit = CAST('${receiptDeliverData.Date_Edit}' AS DATETIME2),"
        "Time_Edit = CAST('${receiptDeliverData.Time_Edit}' AS DATETIME2) ,F_Date_R = CAST('${receiptDeliverData.Time_Edit}' AS DATETIME2),F_Arrival_Time_R = '${receiptDeliverData.F_Arrival_Time_R}',"
        "F_Leaving_Time_R = '${receiptDeliverData.F_Leaving_Time_R}', F_Id_R = ${receiptDeliverData.F_Id_R}, $crewList , F_Attachment = CONVERT(VARBINARY(MAX), '$pdfInHexFormate' , 2)"
        " WHERE $receiptDeliverQuery;";
    try {
      debugPrint(query);
      await SqlConn.writeData(query);
      context.popUp();
      context.snackBar(dataHasBeenUpdated, color: Colors.green.shade900);
    } catch (e) {
      context.snackBar(dataHasNotBeenUpdated, color: Colors.red.shade900);
      debugPrint(e.toString());
    }
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

  String _updateReceiptQuery(List<ReceiptDeliver> receiptDeliver) {
    String receiptDeliverQuery = "";

    for (int x = 0; x < receiptDeliver.length; x++) {
      receiptDeliverQuery += "F_Recipt_No = ${receiptDeliver[x].F_Recipt_No}";
      if (x < receiptDeliver.length - 1) {
        receiptDeliverQuery += " AND ";
      }
    }

    return receiptDeliverQuery;
  }

  bool _missingDataCheck() {
    bool check = false;
    if (receiptDeliverData.deliverReceipts.isEmpty ||
        receiptDeliverData.F_Arrival_Time_R == null ||
        receiptDeliverData.F_Leaving_Time_R == null) {
      check = true;
      context.snackBar(receiptDeliverDataMissing, color: Colors.red.shade900);
    }
    return check;
  }

  bool _missingImageCheck() {
    bool check = false;
    if (receiptImageList.isEmpty) {
      check = true;
      context.snackBar(receiptDeliverImageMissing, color: Colors.red.shade900);
    }
    return check;
  }

  bool _notConnectedToDatabase() {
    bool check = false;
    if (!SqlConn.isConnected) {
      check = true;
      internetConnectionListener = InternetConnectionCubit
          .isConnectedToInternet.stream
          .listen(_internetConnectionListenerFoSubmittingReceipt);
      context.snackBar(pleaseConnectToInternet, color: Colors.red.shade900);
    }
    return check;
  }

  _internetConnectionListenerForRetrevingData(bool isConnected) {
    if (isConnected && SqlConn.isConnected) {
      _getRecieptData();
      internetConnectionListenerForRetrevingData!.cancel();
      internetConnectionListenerForRetrevingData = null;

    }
  }

  _internetConnectionListenerFoSubmittingReceipt(bool isConnected) {
    if (isConnected && SqlConn.isConnected) {
      context.snackBar(receiptDeliverCanBeDeliverd,
          color: Colors.green.shade900);
      internetConnectionListener!.cancel();
      internetConnectionListener = null;
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
    List<User> allUsers = User.fromJsonStringListToUserList(
        Prefs.getString(allUsersFromLocaleDataBase)!);
    for (User user in allUsers) {
      if (user.F_EmpID == empId) {
        bool doesThisEmpAddedBefore = false;
        for (CrewMember crewMember in receiptDeliverData.CrewIdList) {
          if (crewMember.F_EmpID == empId) doesThisEmpAddedBefore = true;
        }
        if (doesThisEmpAddedBefore) {
          return setState(() {
            if (!isCam) isAddingEmployee = false;
            if (isCam) cameraController.start();
            if (!isCam) {
              context.snackBar(thisEmpIsAddedBefore,
                  color: Colors.red.shade900);
            }
          });
        }
        _showMyDialog(user, isCam);
        return;
      }
    }
    if (isCam) cameraController.start();
    if (!isCam) isAddingEmployee = false;
    if (!isCam) context.snackBar(cantFindEmp, color: Colors.red.shade900);
    setState(() {});
  }

  _setCrewlist() {
    User userData = context.read<UserCubit>().state!;
    CrewMember crewLeader =
        CrewMember(F_EmpID: userData.F_EmpID, F_EmpName: userData.F_EmpName);

    receiptDeliverData.F_Id_R = widget.journey.F_Id;
    receiptDeliverData.Userid_Edit_ID = widget.journey.F_Emp_Id.toString();
    if (widget.journey.receiptList.isEmpty) {
      receiptDeliverData.CrewIdList.add(crewLeader);
    } else {
      receiptDeliverData.CrewIdList = widget.journey
          .receiptList[widget.journey.receiptList.length - 1].CrewIdList;
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
          content: Text(addingEmpAlertDialogBody(user.F_EmpName),
              textDirection: TextDirection.rtl),
          actions: <Widget>[
            TextButton(
              child: const Text(confirm),
              onPressed: () {
                CrewMember crewMember = CrewMember(
                    F_EmpID: user.F_EmpID, F_EmpName: user.F_EmpName);
                receiptDeliverData.CrewIdList.add(crewMember);
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
    if (receiptDeliverData.CrewIdList.length >= 6) {
      if (cameraController.isStarting) stopQRDetection();
      Timer(const Duration(milliseconds: 700), () {
        canWeAddMoreEmp = false;
        setState(() {});
      });
    }
  }

  _onTimeSelected(Time timeParameter, isArrivingTime) {
    String time = timeParameter.hourOfPeriod < 10
        ? "0${timeParameter.hourOfPeriod}"
        : timeParameter.hourOfPeriod.toString();

    time +=
        ":${timeParameter.minute < 10 ? "0${timeParameter.minute}" : timeParameter.minute == 0 ? "00" : timeParameter.minute}";
    time += timeParameter.period.name;
    if (isArrivingTime) {
      receiptDeliverData.F_Arrival_Time_R = time;
    } else {
      receiptDeliverData.F_Leaving_Time_R = time;
    }

    setState(() {});
  }

  _setCustomerList() {
    String? customerListString = Prefs.getString(customersInfo);
    if (customerListString != null) {
      customerList =
          Customer.fromJsonStringListToCustomerList(customerListString);
    }
  }

  bool _sqlConnectionChecker() {
    return SqlConn.isConnected;
  }

  _getRecieptData() async {
    debugPrint("customerData");
    String query =
        "SELECT F_Recipt_No , F_Paper_No FROM dbo.T_Deliver_Recieve_M  WHERE F_Bank_Id_R =${customerR!.CustID} AND F_Branch_Id_R =${customerBranchR!.F_Branch_Id} AND F_Arrival_Time_R IS NULL";
    String customerData = await SqlConn.readData(query);
    debugPrint("customerData");
    debugPrint(customerData);
    receiptDeliverList =
        ReceiptDeliver.fromJsonStringListToReceiptDeliverList(customerData);
    setState(() {});
  }

  Future<Uint8List> _convertImagesToPDF() async {
    pw.Document pdf = pw.Document();
    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a6,
        build: (pw.Context context) {
          return [
            for (var image in receiptImageList)
              pw.Container(height: 481, child: pw.Image(pw.MemoryImage(image)))
          ];
        })); // Page
    return await pdf.save();
  }
}
