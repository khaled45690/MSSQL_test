// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../Utilities/Style.dart';
import '../Utilities/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final double width;
  final bool isEnabled;
  final bool isLoading;
  final Function() onClick;

  const CustomButton(this.text, this.width, this.onClick,
      {super.key, this.isEnabled = true, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        color: isEnabled ? mainBlue : disbleButtonColor,
      ),
      child: InkWell(
          splashColor: Colors.red,
          onTap: isEnabled ? onClick : null,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              text,
              style: authButtonTextStyle,
            ),
            isLoading
                ? Image.asset(
                    "assets/images/loading.gif",
                    fit: BoxFit.fitHeight,
                    width: 30,
                  )
                : const SizedBox()
          ])),
    );
  }
}
