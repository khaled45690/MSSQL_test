import 'package:flutter/material.dart';

import '../../../../Utilities/Style.dart';
import 'DropDownWithSearch.dart';

class ReceiverData extends StatelessWidget {
  final List<String> list;
  final String? text;
  final List<String> Function(List<String> list, String? search) onTextChange;
  final Function(String item) onItemChange;

  const ReceiverData(this.list, this.onTextChange, this.onItemChange, this.text,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Row(
          textDirection: TextDirection.rtl,
          children: [
            const Text(
              "كود المستلم",
              style: cartExpensesPriceTextStyle,
            ),
            DropDownWithSearch(list, onTextChange, onItemChange, text)
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          textDirection: TextDirection.rtl,
          children: [
            const Text(
              "كود البنك",
              style: cartExpensesPriceTextStyle,
            ),
            DropDownWithSearch(list, onTextChange, onItemChange, text)
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          textDirection: TextDirection.rtl,
          children: [
            const Text(
              "كود الفرع",
              style: cartExpensesPriceTextStyle,
            ),
            DropDownWithSearch(list, onTextChange, onItemChange, text)
          ],
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
