import 'package:flutter/cupertino.dart';

import '../../../../Utilities/Style.dart';
import 'DropDownWithSearch.dart';

class EmployeeWithCar extends StatelessWidget {
  final List<String> list;
  final String? text;
  final List<String> Function(List<String> list, String? search) onSearchChange;
  final Function(String item) onItemChange;
  final int numEmployeeWithCar;
  const EmployeeWithCar(this.list, this.onSearchChange, this.onItemChange,
      this.text, this.numEmployeeWithCar,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 20),
      decoration: BagsContentDecoration,
      child: Column(
        children: [
          for (int i = 1; i <= numEmployeeWithCar; i++)
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text(
                    "المرافق $i",
                    style: cartExpensesPriceTextStyle,
                  ),
                  SizedBox(width: 10,),
                  DropDownWithSearch(list, onSearchChange, onItemChange, text)
                ],
              ),
            ),
        ],
      ),
    );
  }
}
