import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sql_test/MainWidgets/CustomButton.dart';

import 'package:sql_test/Utilities/Extentions.dart';
import 'package:sql_test/Utilities/colors.dart';

import '../../../MainWidgets/CustomElementSelector.dart';
import '../../../MainWidgets/QRCodeDetection.dart';
import '../../../MainWidgets/SearchButtonSheet.dart';
import '../../../Utilities/Style.dart';
import 'Controller/DeliverScreenController.dart';
import 'Widgets/AddEmployeeByWriting.dart';
import 'Widgets/AddingCheckHeaderAndButton.dart';
import 'Widgets/ShowAddedEmployee.dart';

class DeliverScreen extends StatefulWidget {
  const DeliverScreen({super.key});

  @override
  State<DeliverScreen> createState() => _DeliverScreenState();
}

class _DeliverScreenState extends DeliverScreenController {
  List employees = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: mainBlue),
      body: Builder(
        builder: (context) => Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: context.width(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("الطاقم", style: size22BlackTextStyle),
                  addingEmployeeButton(),
                  QRCodeDetection(height, cameraController),
                  const AddEmployeeByWriting(false),
                  CustomListView(employees),
                  AddingCheckHeaderAndButton(false, addChecks),
                  CustomListView(employees),
                  CustomElementSelector("اسم العميل", "اختر من هنا",
                      () => searchButtonSheet(context)),
                  CustomElementSelector("اسم الفـرع", "اختر من هنا",
                      () => searchButtonSheet(context)),
                  CustomElementSelector(
                      "وقت التحرك", "اختر من هنا", () => selectTime(context)),
                  CustomElementSelector(
                      "وقت الوصول", "اختر من هنا", () => selectTime(context)),
const SizedBox(height: 20,),
                      CustomButton("تسليم", 200, () => null),
                      const SizedBox(height: 80,),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
