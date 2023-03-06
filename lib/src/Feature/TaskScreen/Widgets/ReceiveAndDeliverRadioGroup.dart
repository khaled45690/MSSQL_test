import 'package:flutter/material.dart';

import '../../../../Utilities/Style.dart';

class ReceiveAndDeliverRadioGroup extends StatelessWidget {
  final String radioGroupValue;
  final Function(String) onRadioChangeCallback;
  const ReceiveAndDeliverRadioGroup(
      {super.key,
      required this.radioGroupValue,
      required this.onRadioChangeCallback});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          onTap: () => onRadioChangeCallback("Receive"),
          child: Row(
            children: [
              const Text(
                "استلام",
                style: size19BlackTextStyle,
              ),
              Radio(
                  value: "Receive",
                  groupValue: radioGroupValue,
                  onChanged: (value) => onRadioChangeCallback("Receive"))
            ],
          ),
        ),
        InkWell(
          onTap: () => onRadioChangeCallback("Deliver"),
          child: Row(
            children: [
              const Text(
                "تسليم",
                style: size19BlackTextStyle,
              ),
              Radio(
                value: "Deliver",
                groupValue: radioGroupValue,
                onChanged: (value) => onRadioChangeCallback("Deliver")
              )
            ],
          ),
        ),
      ],
    );
  }
}
