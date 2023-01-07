import 'package:flutter/material.dart';

import '../../../../Utilities/Style.dart';
import 'DropDownWithSearch.dart';
import 'package:intl/intl.dart' as format;

class SenderData extends StatelessWidget {
  final List<String> list;
  final String? text;
  final List<String> Function(List<String> list, String? search) onTextChange;
  final Function(String item) onItemChange;

  const SenderData(this.list, this.onTextChange, this.onItemChange, this.text,
      {super.key});

  @override
  Widget build(BuildContext context) {
    String date = format.DateFormat('dd-MM-yyyy').format(DateTime.now());
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Row(
          textDirection: TextDirection.rtl,
          children: [
            const Text(
              "التاريخ",
              style: cartExpensesPriceTextStyle,
            ),
            const SizedBox(
              width: 15,
            ),
            RawMaterialButton(
              onPressed: () {},
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: dropDownDecoration,
                child: Text(
                  date,
                  style: cartExpensesPriceTextStyle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          textDirection: TextDirection.rtl,
          children: [
            const Text(
              "مرسل الى البنك",
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
