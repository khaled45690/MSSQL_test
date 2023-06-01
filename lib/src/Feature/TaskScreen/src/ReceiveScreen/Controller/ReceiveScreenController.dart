import 'dart:async';
import 'dart:typed_data';

import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sql_test/src/DataTypes/CrewMember.dart';
import 'package:sql_test/src/DataTypes/Customer.dart';
import 'package:sql_test/src/DataTypes/CustomerBranch.dart';
import 'package:sql_test/src/Feature/JourneyScreen/JourneyScreen.dart';
import 'package:sql_test/src/Utilities/Extentions.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sql_test/src/Utilities/VariableCodes.dart';
import '../../../../../DataTypes/ReceiptDetails.dart';
import '../../../../../DataTypes/ReceiptType.dart';
import '../../../../../DataTypes/User.dart';
import '../../../../../MainWidgets/CustomButton.dart';
import '../../../../../Utilities/Prefs.dart';
import '../../../../../Utilities/Strings.dart';
import '../ReceiveScreen.dart';
import '../src/ReceiveDetailsScreen.dart';

abstract class ReceiveScreenController extends State<ReceiveScreen> {
  MobileScannerController cameraController =
      MobileScannerController(facing: CameraFacing.back);
  double height = 0;
  bool isAddingEmployee = false,
      isSearchingForEmploy = false,
      canWeAddMoreEmp = true,
      isCustomerSelected = false,
      isCustomerRSelected = false;
  String empIdFromTextField = "";
  List<Customer> customerList = [];
  List<CustomerBranch> customerBranchList = [];
  List<CustomerBranch> customerBranchListR = [];
  final ImagePicker _picker = ImagePicker();
  List<Uint8List> receiptImageList = [];
  List<ReceiptType> receiptTypeList = [
    ReceiptType(receiptTypeNumber: 0, receiptTypeName: 'تسليم'),
    ReceiptType(receiptTypeNumber: 1, receiptTypeName: 'فرز'),
    ReceiptType(receiptTypeNumber: 2, receiptTypeName: 'محصنة')
  ];
  TextEditingController receiptNOController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController note1Controller = TextEditingController();
  TextEditingController empTextFilledAdder = TextEditingController();
  @override
  void initState() {
    super.initState();
    _setCustomerList();
    _setCustomerBranches();
    _stopCameraAtStart();
    receiptNOController.text = widget.receipt.F_Paper_No ?? '';
    noteController.text = widget.receipt.F_Note;
    note1Controller.text = widget.receipt.F_Note1;
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
      case "AddNote":
        widget.receipt.F_Note = value;
        break;
      case "AddNote1":
        widget.receipt.F_Note1 = value;
        break;
      case "F_Paper_No":
        widget.receipt.F_Paper_No = value;
        break;
      default:
    }
    widget.parsedFunction(widget.receipt);
    setState(() {});
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

  addEmpByTextFunc() {
    _addEmpByCam(empIdFromTextField, false);
  }

  onSelectCustomerFunc(Customer customer, bool isDeliveredTo) {
    if (isDeliveredTo) {
      widget.receipt.F_Cust_R = customer;
      isCustomerRSelected = true;
      widget.parsedFunction(widget.receipt);
      customerBranchListR = customer.CustomerBranches;
    } else {
      widget.receipt.F_Cust = customer;
      isCustomerSelected = true;
      widget.parsedFunction(widget.receipt);
      customerBranchList = customer.CustomerBranches;
    }
    setState(() {});
  }

  onSelectCustomerBranchFunc(
      CustomerBranch customerBranch, bool isDeliveredTo) {
    if (isDeliveredTo) {
      widget.receipt.F_Branch_Internal_R = customerBranch.F_Branch_Internal;
      widget.receipt.F_Branch_R = customerBranch;
      widget.parsedFunction(widget.receipt);
    } else {
      widget.receipt.F_Branch_Internal_D = customerBranch.F_Branch_Internal;
      widget.receipt.F_Branch_D = customerBranch;
      widget.parsedFunction(widget.receipt);
    }
    setState(() {});
  }

  onSelectreceiptTypeFunc(ReceiptType receiptType) {
    widget.receipt.F_Recipt_Type = receiptType;
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

  pickDate(bool isArriveTime) async {
    Navigator.of(context).push(showPicker(
      context: context,
      value: Time(hour: DateTime.now().hour, minute: DateTime.now().minute),
      onChange: (onTimeChanged) => _onTimeSelected(onTimeChanged, isArriveTime),
    ));
  }

  goToRecieveDetailsScreen() {
    context.navigateTo(ReceiveDetailsScreen(
        _addReceiptDetails,
        widget.receipt.F_Recipt_No,
        widget.receipt.ReceiptDetailsList.length + 1));
    setState(() {});
  }

  saveReceipt() async {
    if (_customAndCustomerRAndPaperNoCheck()) return;
    if (_branchAndBranchRCheck()) return;
    if (_receiptDetailsCheck()) return;
    if (_receiptDateCheck()) return;

    widget.receipt.Time_Save = DateTime.now().toString();
    if (receiptImageList.isNotEmpty)
      widget.receipt.imagesAsPDF = await _convertImagesToPDF();
    widget.saveReceiptInJouerny(widget.receipt);
  }

  bool _receiptDateCheck() {
    bool check = false;
    if (widget.receipt.F_Arrival_Time_D == null ||
        widget.receipt.F_Leaving_Time_D == null) {
      check = true;
      context.snackBar(arrivalAndLeavingDateNotEntered, color: Colors.red);
    }
    return check;
  }

  deleteReciept(int index) {
    List<ReceiptDetails> filter = [];
    for (int i = 0; i < widget.receipt.ReceiptDetailsList.length; i++) {
      if (i != index) {
        filter.add(widget.receipt.ReceiptDetailsList[i]);
      } else if (i == index) {
        if (widget.receipt.ReceiptDetailsList[i].F_Currency_Type ==
            LocalCurrency) {
          widget.receipt.F_Local_Tot -=
              widget.receipt.ReceiptDetailsList[i].F_EGP_Amount;
        } else if (widget.receipt.ReceiptDetailsList[i].F_Currency_Type ==
            ForeignCurrency) {
          widget.receipt.F_Global_Tot -=
              widget.receipt.ReceiptDetailsList[i].F_Total_val;
        }
        widget.receipt.F_totalAmount_EGP -=
            widget.receipt.ReceiptDetailsList[i].F_EGP_Amount;
        widget.parsedFunction(widget.receipt);
      }
    }
    widget.receipt.ReceiptDetailsList = filter;
    widget.parsedFunction(widget.receipt);
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

  bool _customAndCustomerRAndPaperNoCheck() {
    bool check = false;

    if (widget.receipt.F_Cust == null ||
        widget.receipt.F_Paper_No == null ||
        widget.receipt.F_Cust_R == null) {
      check = true;
      context.snackBar(customerAndPaperNoAndCustomerRNotEntered,
          color: Colors.red);
    }
    return check;
  }

  bool _branchAndBranchRCheck() {
    bool check = false;
    if (widget.isEdit) return check;
    if (widget.receipt.F_Branch_D == null ||
        widget.receipt.F_Branch_R == null ||
        receiptImageList.isEmpty) {
      check = true;
      context.snackBar(branchAndBranchRandImagesNotEntered, color: Colors.red);
    }
    return check;
  }

  bool _receiptDetailsCheck() {
    bool check = false;
    if (widget.receipt.ReceiptDetailsList.isEmpty) {
      check = true;
      context.snackBar(receiptDetailsNotEntered, color: Colors.red);
    }
    return check;
  }

  _addReceiptDetails(ReceiptDetails receiptDetails) {
    widget.receipt.ReceiptDetailsList.add(receiptDetails);
    if (receiptDetails.F_Currency_Type == LocalCurrency) {
      widget.receipt.F_Local_Tot += receiptDetails.F_EGP_Amount;
    } else if (receiptDetails.F_Currency_Type == ForeignCurrency) {
      widget.receipt.F_Global_Tot += receiptDetails.F_Total_val;
    }
    widget.receipt.F_totalAmount_EGP += receiptDetails.F_EGP_Amount;
    widget.parsedFunction(widget.receipt);
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
    if (widget.receipt.CrewIdList.length >= maxEmpSize) {
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
    if (widget.receipt.F_Cust_R != null) {
      isCustomerRSelected = true;
      customerBranchList = widget.receipt.F_Cust_R!.CustomerBranches;
    }
  }

  _stopCameraAtStart() {
    Timer(const Duration(milliseconds: 500), () => {cameraController.stop()});
  }

  _onTimeSelected(Time timeParameter, isArrivingTime) {
    String time = timeParameter.hourOfPeriod < 10
        ? "0${timeParameter.hourOfPeriod}"
        : timeParameter.hourOfPeriod.toString();

    time +=
        ":${timeParameter.minute < 10 ? "0${timeParameter.minute}" : timeParameter.minute == 0 ? "00" : timeParameter.minute}";
    time += timeParameter.period.name;
    if (isArrivingTime) {
      widget.receipt.F_Arrival_Time_D = time;
    } else {
      widget.receipt.F_Leaving_Time_D = time;
    }
    widget.parsedFunction(widget.receipt);
    setState(() {});
  }
}
