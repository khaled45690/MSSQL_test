// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sql_test/src/Utilities/Extentions.dart';

import '../../../../../../MainWidgets/CustomTextField.dart';
import '../../../../../../Utilities/Style.dart';




class TextFieldWithName extends StatelessWidget {
  final String text;
  final Function(String value) onTextChangeFunction;
  final bool isNumber;
   final TextEditingController? textEditingController;
  const TextFieldWithName(this.text,
      {super.key, required this.onTextChangeFunction , this.isNumber = false , this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top : 15 , left: 25 , right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          Text(
            text,
            style: size19BlackTextStyle,
          ),
          CustomTextField(onTextChangeFunction, context.width() / 1.3 , isNumber: isNumber , textEditingController: textEditingController),
        ],
      ),
    );
  }
}
