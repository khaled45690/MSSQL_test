import 'package:flutter/material.dart';

import '../../../../../../MainWidgets/CustomTextField.dart';
import '../../../../../../Utilities/Style.dart';

class TextFieldWithName extends StatelessWidget {
  final String text;
  final Function(String value) onTextChangeFunction;
  const TextFieldWithName(this.text,
      {super.key, required this.onTextChangeFunction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top : 15 , left: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          Text(
            text,
            style: size19BlackTextStyle,
          ),
          CustomTextField(onTextChangeFunction, 250),
        ],
      ),
    );
  }
}
