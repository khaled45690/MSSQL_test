// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../../DataTypes/Receipt.dart';
import '../../../../../MainWidgets/BottonSheets/searchButtonSheetForTransferReciept.dart';
import '../../../../../MainWidgets/CustomButton.dart';
import '../../../../../MainWidgets/CustomElementSelector.dart';
import '../../../../../MainWidgets/QRCodeDetection.dart';
import '../ExternalReceive/Widgets/AddEmployeeByWriting.dart';
import '../ExternalReceive/Widgets/CustomListView.dart';
import '../ExternalReceive/Widgets/TextFieldWithName.dart';
import 'Controller/InternalReceiveController.dart';
import 'Widgets/TransferedRecieptListView.dart';

class InternalReceive extends StatefulWidget {
  final List<Receipt> receipts;
  static List<Receipt> receiptss = [];
  final Function(Receipt receiptParameter, int receiptIndex, bool isFinalyEdited) editReceiptInJouerny;
  const InternalReceive({super.key, required this.receipts, required this.editReceiptInJouerny});
  @override
  State<InternalReceive> createState() => _InternalReceiveState();
}

class _InternalReceiveState extends InternalReceiveController {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        addingEmployeeButton(),
        QRCodeDetection(height, onCapture, cameraController),
        AddEmployeeByWriting(
          isAddingEmployee,
          canWeAddMoreEmp,
          (value) => onTextChange("AddEmpByText", value),
          onTap: addEmpByTextFunc,
          empTextFilledAdder: empTextFilledAdder,
        ),
        CustomListView(receiptInternalReceiveData.CrewIdList, removeEMp),
        CustomElementSelector(
            text: "",
            width: 300,
            selectedElementText: " اختر الوصلات التى سيتم استلامها",
            onTap: () => searchButtonSheetForTransferReciept(context, transferReceiptFilterList, onSelectReceiptFunc),
            isvisible: true),
        TransferedRecieptListView(selectedTransferReceiptList, removeReceiptDeliver),
        TextFieldWithName("ملاحـظـــة", onTextChangeFunction: (String value) => onTextChange("AddNote", value)),
        const SizedBox(height: 60),
        CustomButton("قم بالاستلام  ", 250, receiveReceipts, isLoading: isLoading, isEnabled: !isLoading),
        const SizedBox(height: 100,)
      ],
    );
  }
}
