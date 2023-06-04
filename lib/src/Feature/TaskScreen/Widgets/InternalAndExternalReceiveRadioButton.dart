//InternalAndExternalReceiveRadioButton


// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../Utilities/Style.dart';
import '../../../Utilities/VariableCodes.dart';


class InternalAndExternalReceiveRadioButton extends StatelessWidget {
  final int radioGroupValue;
  final Function(int) onRadioChangeCallback;
  const InternalAndExternalReceiveRadioButton(
      {super.key,
      required this.radioGroupValue,
      required this.onRadioChangeCallback});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          onTap: () => onRadioChangeCallback(InternalReceiving),
          child: Row(
            children: [
              const Text(
                "استلام داخلى",
                style: size19BlackTextStyle,
              ),
              Radio(
                  value: InternalReceiving,
                  groupValue: radioGroupValue,
                  onChanged: (value) => onRadioChangeCallback(InternalReceiving))
            ],
          ),
        ),
        InkWell(
          onTap: () => onRadioChangeCallback(ExternalReceiving),
          child: Row(
            children: [
              const Text(
                "استلام خارجى",
                style: size19BlackTextStyle,
              ),
              Radio(
                value: ExternalReceiving,
                groupValue: radioGroupValue,
                onChanged: (value) => onRadioChangeCallback(ExternalReceiving)
              )
            ],
          ),
        ),
      ],
    );
  }
}
