import 'package:flutter/material.dart';
import 'package:sql_test/Utilities/Extentions.dart';

import '../Utilities/Style.dart';
import '../Utilities/colors.dart';

class SearchTextField extends StatelessWidget {
  final String hint = "";
  final Function(String variableName, String value) onChange;

  const SearchTextField(this.onChange);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        width: context.width() - 100,
        height: 40,
        child: TextField(


            cursorColor: mainBlue,
            onChanged: (value) => onChange(hint, value),
            showCursor: true,
            enabled: true,
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
              
              focusedBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(60) ,borderSide: BorderSide(width: 1.5, color: mainBlue)),
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white.withOpacity(0.4),
              focusColor: mainBlue,
              alignLabelWithHint: true,
            
              hintStyle: textfieldHintStyle,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(60) ,borderSide: BorderSide(width: 0)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(60) ,borderSide: BorderSide(width: 1 , color: Colors.white.withOpacity(0.4))),
              hintText: hint,
            )),
      ),
    );
  }
}