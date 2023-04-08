import 'package:flutter/material.dart';
import 'package:sql_test/src/Utilities/Extentions.dart';
import 'package:sql_test/src/Feature/TaskScreen/src/DeliverTaskScreen/widgets/ReceiptDeliverListView.dart';

import '../../../../DataTypes/Journey.dart';
import '../../../../MainWidgets/BottonSheets/SearchButtonSheetForBranch.dart';
import '../../../../MainWidgets/BottonSheets/SearchButtonSheetForCustomer.dart';
import '../../../../MainWidgets/BottonSheets/searchButtonSheetForReceiptDeliverType.dart';
import '../../../../MainWidgets/CustomButton.dart';
import '../../../../MainWidgets/CustomElementSelector.dart';
import '../../../../MainWidgets/QRCodeDetection.dart';
import '../ReceiveScreen/Widgets/AddEmployeeByWriting.dart';
import '../ReceiveScreen/Widgets/AddImageToReceipt.dart';
import '../ReceiveScreen/Widgets/CustomListView.dart';
import '../ReceiveScreen/Widgets/DatePickerWidget.dart';
import 'controller/DeliverTaskController.dart';

class DeliverTaskScreen extends StatefulWidget {
  final Journey journey;
  const DeliverTaskScreen(this.journey, {super.key});

  @override
  State<DeliverTaskScreen> createState() => _DeliverTaskScreenState();
}

class _DeliverTaskScreenState extends DeliverTaskController {
  late GlobalKey key;

  @override
  void initState() {
    super.initState();
    key = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              CustomListView(receiptDeliverData.CrewIdList, removeEMp),
              CustomElementSelector(
                text: "اسم العميل المرسل اليه",
                selectedElementText:
                    customerR == null ? "اختر من هنا" : customerR!.CustName,
                onTap: () => searchButtonSheetForCustomer(key.currentContext!,
                    customerList, onSelectCustomerFunc, true),
              ),
              CustomElementSelector(
                text: " اسم الفـرع المرسل اليه",
                selectedElementText: customerBranchR == null
                    ? "اختر من هنا"
                    : customerBranchR!.F_Branch_Name,
                onTap: () => searchButtonSheetForBranch(key.currentContext!,
                    customerBranchListR, onSelectCustomerBranchFunc, true),
                isvisible: isCustomerRSelected,
              ),
              receiptDeliverList.isNotEmpty
                  ? Column(
                      children: [
                        CustomElementSelector(
                          text: "",
                          width: 300,
                          selectedElementText:
                              " اختر الوصلات التى سيتم تسليمها",
                          onTap: () => searchButtonSheetForReceiptDeliverType(
                              key.currentContext!,
                              receiptDeliverList,
                              onSelectReceiptFunc),
                          isvisible: isCustomerRSelected,
                        ),
                        ReceiptDeliverListView(
                            receiptDeliverData.deliverReceipts,
                            removeReceiptDeliver),
                        DatePickerWidget(
                            arrivalDate: receiptDeliverData.F_Arrival_Time_R,
                            leavingDate: receiptDeliverData.F_Leaving_Time_R,
                            pickDate: pickDate),
                        CustomButton(
                            "اضف صور الوصل الممضى", 300, takeReciptPicture),
                        AddImageToReceipt(
                            receiptImageList, removeReciptPicture),
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
          ),
        ),
      ),
    );
  }
}
