import 'package:flutter/material.dart';
import 'package:sql_test/MainWidgets/SearchButtonSheetForBranch.dart';
import 'package:sql_test/Utilities/Extentions.dart';

import '../../../../../MainWidgets/CustomElementSelector.dart';
import '../../../../../MainWidgets/QRCodeDetection.dart';
import '../../../../../MainWidgets/SearchButtonSheetForCustomer.dart';
import '../../../../../DataTypes/Receipt.dart';
import 'Controller/ReceiveScreenController.dart';
import 'Widgets/AddEmployeeByWriting.dart';
import 'Widgets/CustomListView.dart';
import 'Widgets/TextFieldWithName.dart';

class ReceiveScreen extends StatefulWidget {
  final Receipt receipt;
  final Function(Receipt receiptParameter) parsedFunction;
  const ReceiveScreen(this.receipt, this.parsedFunction, {super.key});

  @override
  State<ReceiveScreen> createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends ReceiveScreenController {
  late GlobalKey key;

  @override
  void initState() {
    // TODO: implement initState
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
                  onTap: () => searchButtonSheetForCustomer(
                      key.currentContext!, customerList, onSelectCustomerFunc , false),
                ),
                CustomElementSelector(
                  text: "اسم الفـرع",
                  selectedElementText: widget.receipt.F_Branch_D == null
                      ? "اختر من هنا"
                      : widget.receipt.F_Branch_D!.F_Branch_Name,
                  onTap: () => searchButtonSheetForBranch(key.currentContext!,
                      customerBranchList, onSelectCustomerBranchFunc , false),
                  isvisible: isCustomerSelected,
                ),
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
                  onTap: () => searchButtonSheetForCustomer(
                      key.currentContext!, customerList, onSelectCustomerFunc , true),
                ),
                CustomElementSelector(
                  text: " اسم الفـرع المرسل اليه",
                  selectedElementText: widget.receipt.F_Branch_R == null
                      ? "اختر من هنا"
                      : widget.receipt.F_Branch_R!.F_Branch_Name,
                  onTap: () => searchButtonSheetForBranch(key.currentContext!,
                      customerBranchList, onSelectCustomerBranchFunc , true),
                  isvisible: isCustomerSelected,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
