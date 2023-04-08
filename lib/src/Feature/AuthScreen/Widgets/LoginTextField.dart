import 'package:flutter/material.dart';
import 'package:sql_test/src/Utilities/Extentions.dart';

import '../../../Utilities/Style.dart';
import '../../../Utilities/colors.dart';

class LoginTextField extends StatelessWidget {
  final String hint = "" , variableName;
  final String? errorText;
  final Function(String value ,String variableName) onChange;

  const LoginTextField(this.onChange ,this.variableName, this.errorText);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        width: context.width() - 100,
        child: TextField(
        
            cursorColor: mainBlue,
            onChanged: (value) => onChange(value, variableName),
            showCursor: true,
            enabled: true,
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
              
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 1.5, color: mainBlue)),
              filled: true,
              fillColor: mainBlue.withOpacity(0.1),
              focusColor: mainBlue,
              alignLabelWithHint: true,
              errorText: errorText,
              hintStyle: textfieldHintStyle,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 0)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      width: 1, color: Colors.white.withOpacity(0.4))),
              hintText: hint,
            )),
      ),
    );
  }
}
