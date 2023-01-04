import 'package:flutter/material.dart';
import 'package:sql_test/Utilities/Extentions.dart';

import '../../../../Utilities/Style.dart';
import '../../../../Utilities/colors.dart';

class CustomTextField extends StatelessWidget {
  final String hint = "";
  final Function(String variableName, String value) onChange;

  const CustomTextField(this.onChange);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        width: context.width() - 150,
        height: 40,
        child: TextField(


            cursorColor: mainBlue,
            onChanged: (value) => onChange(hint, value),
            showCursor: true,
            enabled: true,
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
              
              focusedBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15) ,borderSide: BorderSide(width: 1.5, color: mainBlue)),
              filled: true,
              fillColor: Colors.lightGreen.withOpacity(0.2),
              focusColor: mainBlue,
              alignLabelWithHint: true,
            
              hintStyle: textfieldHintStyle,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15) ,borderSide: BorderSide(width: 0)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15) ,borderSide: BorderSide(width: 1 , color: mainBlue.withOpacity(0.7))),
              hintText: hint,
            )),
      ),
    );
  }
}