// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sql_test/src/Utilities/Extentions.dart';

import '../Utilities/Style.dart';
import '../Utilities/colors.dart';

class SearchTextField extends StatelessWidget {
  final String hint = "";
  final Function(String variableName, String value) onChange;
  final bool isNumber;

  const SearchTextField(this.onChange , {super.key, this.isNumber = false});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        width: context.width() - 100,
        height: 40,

        child: TextField(
          keyboardType: isNumber? TextInputType.number : TextInputType.text,
            cursorColor: mainBlue,
            onChanged: (value) => onChange(hint, value),
            showCursor: true,
            enabled: true,
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
              
              focusedBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(60) ,borderSide: const BorderSide(width: 1.5, color: mainBlue)),
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white.withOpacity(0.4),
              focusColor: mainBlue,
              alignLabelWithHint: true,
              hintStyle: textfieldHintStyle,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(60) ,borderSide: const BorderSide(width: 0)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(60) ,borderSide: BorderSide(width: 1 , color: Colors.white.withOpacity(0.4))),
              hintText: hint,
            
            )),
      ),
    );
  }
}