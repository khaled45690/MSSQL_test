import 'package:flutter/material.dart';

import '../../../../Utilities/Colors.dart';
import '../../../../Utilities/Style.dart';

class AddButton extends StatelessWidget {
  final String text;
  final Function() onClick;

   const AddButton(this.text, this.onClick, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
          width: 150,
          height: 50,
          decoration: const  BoxDecoration(
            borderRadius:  BorderRadius.all(Radius.circular(8.0)),
            color: mainBlue,
          ),
          child: Row(
            mainAxisAlignment:  MainAxisAlignment.center,
            children: [
            Text(
                text,
                style: authButtonTextStyle,
              ),
              // isLoading ? Image.asset("${assetUrl}loading.gif" , fit: BoxFit.fitHeight, width:30,): const SizedBox()
          ])),
    );
  }
}