import 'package:flutter/material.dart';

import '../Utilities/Style.dart';

class CustomElementSelector extends StatelessWidget {
  final String text;
  final String selectedElementText;
  final Function() onTap;
  const CustomElementSelector(this.text, this.selectedElementText,this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          Text(
            text,
            style: size19BlackTextStyle,
          ),
          InkWell(
            onTap: onTap,
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(10),
              decoration: lightBlueAccent20percentageWithRadius10Decoration,
              child: Text(selectedElementText, style: size19BlackTextStyle),
            ),
          ),
        ],
      ),
    );
  }
}
