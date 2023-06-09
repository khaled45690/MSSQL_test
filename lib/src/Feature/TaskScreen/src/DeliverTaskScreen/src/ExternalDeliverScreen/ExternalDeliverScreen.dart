// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../../../DataTypes/Journey.dart';
import '../../../../../../MainWidgets/BottonSheets/SearchButtonSheetForBranch.dart';
import '../../../../../../MainWidgets/BottonSheets/SearchButtonSheetForCustomer.dart';
import '../../../../../../MainWidgets/BottonSheets/searchButtonSheetForReceiptDeliverType.dart';
import '../../../../../../MainWidgets/CustomButton.dart';
import '../../../../../../MainWidgets/CustomElementSelector.dart';
import '../../../../../../MainWidgets/QRCodeDetection.dart';

import '../../../ReceiveScreen/ExternalReceive/Widgets/AddEmployeeByWriting.dart';
import '../../../ReceiveScreen/ExternalReceive/Widgets/AddImageToReceipt.dart';
import '../../../ReceiveScreen/ExternalReceive/Widgets/CustomListView.dart';
import '../../../ReceiveScreen/ExternalReceive/Widgets/DatePickerWidget.dart';
import '../../widgets/ReceiptDeliverListView.dart';
import 'Controller/ExternalDeliverScreenController.dart';

class ExternalDeliverScreen extends StatefulWidget {
  final Journey journey;
  const ExternalDeliverScreen(this.journey, {super.key});

  @override
  State<ExternalDeliverScreen> createState() => _ExternalDeliverScreenState();
}

class _ExternalDeliverScreenState extends ExternalDeliverScreenController {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        addingEmployeeButton(),
        QRCodeDetection(height, onCapture, cameraController),
        AddEmployeeByWriting(isAddingEmployee, canWeAddMoreEmp,
            (value) => onTextChange("AddEmpByText", value),
            onTap: addEmpByTextFunc),
        CustomListView(receiptDeliverData.CrewIdList, removeEMp),
        CustomElementSelector(
          text: "اسم العميل المرسل اليه",
          selectedElementText:
              customerR == null ? "اختر من هنا" : customerR!.CustName,
          onTap: () => searchButtonSheetForCustomer(
              context, customerList, onSelectCustomerFunc, true),
        ),
        CustomElementSelector(
          text: " اسم الفـرع المرسل اليه",
          selectedElementText: customerBranchR == null
              ? "اختر من هنا"
              : customerBranchR!.F_Branch_Name,
          onTap: () => searchButtonSheetForBranch(
              context, customerBranchListR, onSelectCustomerBranchFunc, true),
          isvisible: isCustomerRSelected,
        ),
        receiptDeliverList.isNotEmpty
            ? Column(
                children: [
                  CustomElementSelector(
                    text: "",
                    width: 300,
                    selectedElementText: " اختر الوصلات التى سيتم تسليمها",
                    onTap: () => searchButtonSheetForReceiptDeliverType(
                        context, receiptFilteredDeliverList, onSelectReceiptFunc),
                    isvisible: isCustomerRSelected,
                  ),
                  ReceiptDeliverListView(
                      receiptDeliverData.deliverReceipts, removeReceiptDeliver),
                  DatePickerWidget(
                      arrivalDate: receiptDeliverData.F_Arrival_Time_R,
                      leavingDate: receiptDeliverData.F_Leaving_Time_R,
                      pickDate: pickDate),
                  CustomButton("اضف صور الوصل الممضى", 300, takeReciptPicture),
                  AddImageToReceipt(receiptImageList, removeReciptPicture),
                  const SizedBox(
                    height: 50,
                  ),
                  CustomButton("تسليم", 150, submittingReceipts),
                ],
              )
            : const SizedBox(),
        const SizedBox(
          height: 100,
        ),
      ],
    );
  }
}
