import 'package:flutter/material.dart';

import '../../../Utilities/Style.dart';
import 'Widget/CustomTextField.dart';
import 'Widget/DropDownWithSearch.dart';

class DeliveryDataScreen extends StatefulWidget {
  const DeliveryDataScreen({super.key});

  @override
  State<DeliveryDataScreen> createState() => _DeliveryDataScreenState();
}

class _DeliveryDataScreenState extends State<DeliveryDataScreen> {
  List<String> list = <String>[
    'One',
    'Two',
    'Three',
    'Four',
  ];
  List<String> listFilter = [];
  String? searchText;
  String? text;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listFilter = list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
            child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Row(
              textDirection: TextDirection.rtl,
              children: [
                const Text(
                  "كود الايصال",
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
                  "كود العميل",
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
                  "بيـان",
                  style: cartExpensesPriceTextStyle,
                ),
                CustomTextField((da, value) {}),
              ],
            ),
          ],
        )),
      ),
    );
  }

  onItemChange(String item) {
    text = item;
    setState(() {});
  }

  List<String> onSearchChange(List<String> list, String? search) {
    if (search == null) return list;
    List<String> filter = [];
    if (search == null) return list;
    for (var element in list) {
      if (element.length >= search.length) {
        if (element.substring(0, search.length).toLowerCase() ==
            search.toLowerCase()) filter.add(element);
      }
    }
    return filter;
  }
}
