import 'package:flutter/material.dart';
import 'package:sql_test/src/MainWidgets/CustomButton.dart';
import 'package:sql_test/src/Utilities/Extentions.dart';

import '../../../../MainWidgets/BottonSheets/SearchButtonSheetForBranch.dart';
import '../../../../MainWidgets/BottonSheets/SearchButtonSheetForCustomer.dart';
import '../../../../MainWidgets/BottonSheets/searchButtonSheetForReceiptType.dart';
import '../../../../MainWidgets/CustomElementSelector.dart';
import '../../../../MainWidgets/QRCodeDetection.dart';
import '../../../../DataTypes/Receipt.dart';
import 'Controller/ReceiveScreenController.dart';
import 'Widgets/AddEmployeeByWriting.dart';
import 'Widgets/AddImageToReceipt.dart';
import 'Widgets/CustomListView.dart';
import 'Widgets/CustomViewListForReceipts.dart';
import 'Widgets/DatePickerWidget.dart';
import 'Widgets/TextFieldWithName.dart';

class ReceiveScreen extends StatefulWidget {
  final Receipt receipt;
  final Function(Receipt receiptParameter) parsedFunction , saveReceiptInJouerny;
  final bool isEdit;
  const ReceiveScreen(this.receipt, this.parsedFunction, this.saveReceiptInJouerny,this.isEdit,{super.key});

  @override
  State<ReceiveScreen> createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends ReceiveScreenController {
  late GlobalKey key;

  @override
  void initState() {
    super.initState();
    key = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        key: key,
        width: context.width(),
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                addingEmployeeButton(),
                QRCodeDetection(height, onCapture, cameraController),
                AddEmployeeByWriting(isAddingEmployee, canWeAddMoreEmp,
                    (value) => onTextChange("AddEmpByText", value),
                    onTap: addEmpByTextFunc),
                CustomListView(widget.receipt.CrewIdList, removeEMp),
                CustomElementSelector(
                  text: "اسم العميل",
                  selectedElementText: widget.receipt.F_Cust == null
                      ? "اختر من هنا"
                      : widget.receipt.F_Cust!.CustName,
                  onTap: () => searchButtonSheetForCustomer(key.currentContext!,
                      customerList, onSelectCustomerFunc, false),
                ),
                CustomElementSelector(
                  text: "اسم الفـرع",
                  selectedElementText: widget.receipt.F_Branch_D == null
                      ? "اختر من هنا"
                      : widget.receipt.F_Branch_D!.F_Branch_Name,
                  onTap: () => searchButtonSheetForBranch(key.currentContext!,
                      customerBranchList, onSelectCustomerBranchFunc, false),
                  isvisible: isCustomerSelected,
                ),
                TextFieldWithName("رقم الايصال",
                    onTextChangeFunction: (String value) =>
                        onTextChange("F_Paper_No", value),
                    isNumber: true, textEditingController: receiptNOController ),
                TextFieldWithName("بيـــــان",
                    onTextChangeFunction: (String value) =>
                        onTextChange("AddNote", value)),
                TextFieldWithName("ملاحظات",
                    onTextChangeFunction: (String value) =>
                        onTextChange("AddNote1", value)),
                CustomElementSelector(
                  text: "اسم العميل المرسل اليه",
                  selectedElementText: widget.receipt.F_Cust_R == null
                      ? "اختر من هنا"
                      : widget.receipt.F_Cust_R!.CustName,
                  onTap: () => searchButtonSheetForCustomer(key.currentContext!,
                      customerList, onSelectCustomerFunc, true),
                ),
                CustomElementSelector(
                  text: " اسم الفـرع المرسل اليه",
                  selectedElementText: widget.receipt.F_Branch_R == null
                      ? "اختر من هنا"
                      : widget.receipt.F_Branch_R!.F_Branch_Name,
                  onTap: () => searchButtonSheetForBranch(key.currentContext!,
                      customerBranchListR, onSelectCustomerBranchFunc, true),
                  isvisible: isCustomerRSelected,
                ),
                CustomElementSelector(
                  text: "اختر نوع الوصل",
                  selectedElementText:
                      widget.receipt.F_Recipt_Type.receiptTypeName,
                  onTap: () => searchButtonSheetForReceiptType(
                      key.currentContext!,
                      receiptTypeList,
                      onSelectreceiptTypeFunc),
                ),
                CustomButton("اضف صور الوصل", 200, takeReciptPicture),
                AddImageToReceipt(receiptImageList, removeReciptPicture),
                const SizedBox(height: 20),
                CustomButton("اضف تفاصيل الوصل", 200, goToRecieveDetailsScreen),
                CustomViewListForReceipts(widget.receipt.ReceiptDetailsList , deleteReciept),
                const SizedBox(height: 20),
                DatePickerWidget(
                    arrivalDate: widget.receipt.F_Arrival_Time_D,
                    leavingDate: widget.receipt.F_Leaving_Time_D,
                    pickDate: pickDate),
                CustomButton("حفظ الوصل", 200, saveReceipt),
                const SizedBox(height: 100)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
