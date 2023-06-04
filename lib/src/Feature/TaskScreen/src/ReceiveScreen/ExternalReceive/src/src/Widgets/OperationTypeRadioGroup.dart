// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sql_test/src/Utilities/VariableCodes.dart';

import '../../../../../../../../Utilities/Style.dart';


class OperationTypeRadioGroup extends StatelessWidget {
  final int radioGroupValue;
  final Function(int) onRadioChangeCallback;
  const OperationTypeRadioGroup(
      {super.key,
      required this.radioGroupValue,
      required this.onRadioChangeCallback});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          onTap: () => onRadioChangeCallback(LocalCurrency),
          child: Row(
            children: [
              const Text(
                "محلى",
                style: size19BlackTextStyle,
              ),
              Radio(
                  value: LocalCurrency,
                  groupValue: radioGroupValue,
                  onChanged: (value) => onRadioChangeCallback(LocalCurrency)
                  
                  )
            ],
          ),
        ),
        InkWell(
          onTap: () => onRadioChangeCallback(ForeignCurrency),
          child: Row(
            children: [
              const Text(
                "اجنبى",
                style: size19BlackTextStyle,
              ),
              Radio(
                value: ForeignCurrency,
                groupValue: radioGroupValue,
                onChanged: (value) => onRadioChangeCallback(ForeignCurrency)
              )
            ],
          ),
        ),

                InkWell(
          onTap: () => onRadioChangeCallback(CoinsCurrency),
          child: Row(
            children: [
              const Text(
                "عملات",
                style: size19BlackTextStyle,
              ),
              Radio(
                value: CoinsCurrency,
                groupValue: radioGroupValue,
                onChanged: (value) => onRadioChangeCallback(CoinsCurrency)
              )
            ],
          ),
        ),
      ],
    );
  }
}
