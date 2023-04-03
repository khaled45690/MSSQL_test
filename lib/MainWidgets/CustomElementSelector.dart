import 'package:flutter/material.dart';

import '../Utilities/Style.dart';

class CustomElementSelector extends StatelessWidget {
  final String text;
  final String selectedElementText;
  final bool isvisible , isDeliveredTo;
  final double width;
  final Function() onTap;
  const CustomElementSelector({super.key, required this.text, required this.selectedElementText,required this.onTap,this.isvisible = true ,this.isDeliveredTo = true, this.width = 140});

  @override
  Widget build(BuildContext context) {
    return isvisible ? Container(
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
              width: width,
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(10),
              decoration: lightBlueAccent20percentageWithRadius10Decoration,
              child: Text(selectedElementText, style: size19BlackTextStyle , textAlign: TextAlign.center),
            ),
          ),
        ],
      ),
    ) : const SizedBox();
  }
}
