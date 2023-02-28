import 'package:flutter/material.dart';

import '../../../../Utilities/Style.dart';

class ReceiveAndDeliverRadioGroup extends StatelessWidget {
  const ReceiveAndDeliverRadioGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      const Text(
                        "استلام",
                        style: size19BlackTextStyle,
                      ),
                      Radio(
                          value: "radio value",
                          groupValue: "group value",
                          onChanged: (value) {
                            print(value); //selected value
                          }),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "تسليم",
                        style: size19BlackTextStyle,
                      ),
                      Radio(
                          autofocus: true,
                          toggleable: true,
                          value: "radio value",
                          groupValue: "radio value",
                          onChanged: (value) {
                            print(value); //selected value
                          })
                    ],
                  ),
                ],
              );
  }
}