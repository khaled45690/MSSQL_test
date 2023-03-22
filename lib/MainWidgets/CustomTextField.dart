import 'package:flutter/material.dart';

import '../../../../Utilities/Style.dart';
import '../../../../Utilities/colors.dart';

class CustomTextField extends StatelessWidget {
  final String hint = "";
  final bool isNumber;
  final double width;
  final Function(String value) onChange;
  final TextEditingController? textEditingController;

  const CustomTextField(this.onChange, this.width , {super.key , this.isNumber = false , this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        width: width,
        height: 35,
        child: TextField(
          controller: textEditingController,
            cursorColor: mainBlue,
            onChanged: (value) => onChange(value),
            showCursor: true,
            enabled: true,
            textAlignVertical: TextAlignVertical.bottom,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              focusedBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10) ,borderSide: BorderSide(width: 1.5, color: mainBlue)),
              filled: true,
              fillColor: Colors.blueGrey.withOpacity(0.2),
              focusColor: mainBlue,
              alignLabelWithHint: true,
            
              hintStyle: textfieldHintStyle,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10) ,borderSide: BorderSide(width: 0)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10) ,borderSide: BorderSide(width: 1 , color: mainBlue.withOpacity(0.7))),
              hintText: hint,
            )),
      ),
    );
  }
}