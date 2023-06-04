// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../../../../../Utilities/Style.dart';
import '../../../Widgets/TextFieldWithName.dart';



class ReceiptSeals extends StatelessWidget {
  final Function(String variableName, String value) onTextChange;
  final TextEditingController sealTotextEditingController;
  const ReceiptSeals(this.onTextChange ,{super.key , required this.sealTotextEditingController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: decorationWithBorder,
      child: Column(children: [
        const Text(
          "ادخل الوصلات كالاتى",
          style: size22BlackTextStyle,
        ),
        TextFieldWithName("من",
            onTextChangeFunction: (String value) =>
                onTextChange("F_Seal_No_From", value )),
        TextFieldWithName("الى",
            onTextChangeFunction: (String value) =>
                onTextChange("F_Seal_No_To", value) , textEditingController: sealTotextEditingController),
      ]),
    );
  }
}
