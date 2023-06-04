
// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../../Utilities/Style.dart';
import '../../../../../Utilities/VariableCodes.dart';

class InternalAndExternalDeliverRadioButton extends StatelessWidget {
  final int radioGroupValue;
  final Function(int) onRadioChangeCallback;
  const InternalAndExternalDeliverRadioButton(
      {super.key,
      required this.radioGroupValue,
      required this.onRadioChangeCallback});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          onTap: () => onRadioChangeCallback(InternalDelivery),
          child: Row(
            children: [
              const Text(
                "تسليم داخلى",
                style: size19BlackTextStyle,
              ),
              Radio(
                  value: InternalDelivery,
                  groupValue: radioGroupValue,
                  onChanged: (value) => onRadioChangeCallback(InternalDelivery))
            ],
          ),
        ),
        InkWell(
          onTap: () => onRadioChangeCallback(ExternalDelivery),
          child: Row(
            children: [
              const Text(
                "تسليم خارجى",
                style: size19BlackTextStyle,
              ),
              Radio(
                value: ExternalDelivery,
                groupValue: radioGroupValue,
                onChanged: (value) => onRadioChangeCallback(ExternalDelivery)
              )
            ],
          ),
        ),
      ],
    );
  }
}
