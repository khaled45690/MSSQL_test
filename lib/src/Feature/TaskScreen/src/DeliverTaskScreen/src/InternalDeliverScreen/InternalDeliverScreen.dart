// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../../../DataTypes/Journey.dart';
import '../../../../../../MainWidgets/BottonSheets/searchButtonSheetForReceiptDeliverType.dart';
import '../../../../../../MainWidgets/CustomButton.dart';
import '../../../../../../MainWidgets/CustomElementSelector.dart';
import '../../../../../../MainWidgets/QRCodeDetection.dart';
import '../../../ReceiveScreen/ExternalReceive/Widgets/AddEmployeeByWriting.dart';
import '../../../ReceiveScreen/ExternalReceive/Widgets/CustomListView.dart';
import '../../../ReceiveScreen/ExternalReceive/Widgets/TextFieldWithName.dart';
import '../../widgets/ReceiptDeliverListView.dart';
import '../../widgets/ReceiptDeliverViewer.dart';
import 'Controller/InternalDeliverScreenController.dart';

class InternalDeliverScreen extends StatefulWidget {
  final Journey journey;
  const InternalDeliverScreen(this.journey, {super.key});

  @override
  State<InternalDeliverScreen> createState() => _InternalDeliverScreenState();
}

class _InternalDeliverScreenState extends InternalDeliverScreenController {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        addingEmployeeButton(),
        QRCodeDetection(height, onCapture, cameraController),
        AddEmployeeByWriting(
          isAddingEmployee,
          isEmpReceiveIsNotAdded,
          (value) => onTextChange("AddEmpByText", value),
          onTap: addEmpByTextFunc,
          empTextFilledAdder: empTextFilledAdder,
        ),
        CustomListView(receiptInternalDeliverData.CrewIdList, removeEMp),
        CustomElementSelector(
          text: "",
          width: 300,
          selectedElementText: " اختر الوصلات التى سيتم تسليمها",
          onTap: () => searchButtonSheetForReceiptDeliverType(context, receiptFilteredDeliverList, onSelectReceiptFunc),
          isvisible: true,
        ),
        ReceiptDeliverViewer(receiptInternalDeliverData.deliverReceipts, removeReceiptDeliver),
        TextFieldWithName("ملاحـظـــة", onTextChangeFunction: (String value) => onTextChange("AddNote", value)),
        CustomButton("قم بالتسليم  ", 250, deliverReceipts , isLoading: isLoading,  isEnabled: !isLoading),
      ],
    );
  }
}
