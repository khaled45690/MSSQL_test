// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sql_test/src/MainWidgets/CustomButton.dart';
import 'package:sql_test/src/Utilities/Extentions.dart';

import '../../../../../Utilities/Style.dart';

class DatePickerWidget extends StatelessWidget {
  final String? arrivalDate, leavingDate;
  final Function(bool isArrivalTine) pickDate;
  const DatePickerWidget(
      {this.arrivalDate, this.leavingDate, required this.pickDate, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      width: context.width(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomButton("وقت الوصول", 140, () => pickDate(true)),
              Text(
                arrivalDate ?? "",
                style: size19BlackTextStyle,
                textDirection: TextDirection.ltr,
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomButton("وقت الرحيل", 140, () => pickDate(false)),
              Text(
                leavingDate ?? "",
                style: size19BlackTextStyle,
                textDirection: TextDirection.ltr,
              
              )
            ],
          ),
        ],
      ),
    );
  }
}
