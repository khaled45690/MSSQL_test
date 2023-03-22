import 'package:flutter/material.dart';

import '../../../../../../../Utilities/Style.dart';


class CoinsORPaperMoneyRadioGroup extends StatelessWidget {
  final bool radioGroupValue;
  final Function(bool) onRadioChangeCallback;
  const CoinsORPaperMoneyRadioGroup(
      {super.key,
      required this.radioGroupValue,
      required this.onRadioChangeCallback});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          onTap: () => onRadioChangeCallback(false),
          child: Row(
            children: [
              const Text(
                "عملات ورقية",
                style: size19BlackTextStyle,
              ),
              Radio(
                  value: false,
                  groupValue: radioGroupValue,
                  onChanged: (value) => onRadioChangeCallback(false))
            ],
          ),
        ),
        InkWell(
          onTap: () => onRadioChangeCallback(true),
          child: Row(
            children: [
              const Text(
                "عملات معدتية",
                style: size19BlackTextStyle,
              ),
              Radio(
                value: true,
                groupValue: radioGroupValue,
                onChanged: (value) => onRadioChangeCallback(true)
              )
            ],
          ),
        ),
      ],
    );
  }
}
