import 'package:flutter/cupertino.dart';

import '../../../../Utilities/Style.dart';
import 'CustomTextField.dart';
import 'DropDownWithSearch.dart';

class BagsContent extends StatelessWidget {
  final List<String> list;
  final String? text;
  final List<String> Function(List<String> list, String? search) onSearchChange;
  final Function(String item) onItemChange;
  const BagsContent(
      this.list, this.onSearchChange, this.onItemChange, this.text,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20,),
      padding: const EdgeInsets.only(bottom: 20, top: 20, left: 10, right: 10),
      decoration: BagsContentDecoration,
      child: Column(
        children: [
          const Center(
            child: Text(
              "محتوى الشنطة",
              style: cartExpensesPriceTextStyle,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            textDirection: TextDirection.rtl,
            children: [
              const Text(
                "القيمة بالمصرى",
                style: cartExpensesPriceTextStyle,
              ),
              CustomTextField((da, value) {}, isNumber: true),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            textDirection: TextDirection.rtl,
            children: [
              const Text(
                "الوحدة",
                style: cartExpensesPriceTextStyle,
              ),
              DropDownWithSearch(list, onSearchChange, onItemChange, text)
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            textDirection: TextDirection.rtl,
            children: [
              const Text(
                "العملة",
                style: cartExpensesPriceTextStyle,
              ),
              DropDownWithSearch(list, onSearchChange, onItemChange, text)
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            textDirection: TextDirection.rtl,
            children: [
              const Text(
                "عدد الباكو",
                style: cartExpensesPriceTextStyle,
              ),
              CustomTextField((da, value) {}, isNumber: true),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            textDirection: TextDirection.rtl,
            children: [
              const Text(
                "الفئة",
                style: cartExpensesPriceTextStyle,
              ),
              DropDownWithSearch(list, onSearchChange, onItemChange, text)
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            textDirection: TextDirection.rtl,
            children: [
              const Text(
                "عدد الاوراق",
                style: cartExpensesPriceTextStyle,
              ),
              CustomTextField((da, value) {}, isNumber: true),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            textDirection: TextDirection.rtl,
            children: [
              const Text(
                "عدد الكراتين",
                style: cartExpensesPriceTextStyle,
              ),
              CustomTextField((da, value) {}, isNumber: true),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            textDirection: TextDirection.rtl,
            children: [
              const Text(
                "قيمة الكرتونة",
                style: cartExpensesPriceTextStyle,
              ),
              CustomTextField((da, value) {}, isNumber: true),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            textDirection: TextDirection.rtl,
            children: [
              const Text(
                "القيمة",
                style: cartExpensesPriceTextStyle,
              ),
              CustomTextField((da, value) {}, isNumber: true),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
