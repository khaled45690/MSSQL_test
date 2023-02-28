import 'package:flutter/material.dart';
import 'package:sql_test/Utilities/Extentions.dart';

import '../../../../Utilities/Style.dart';

class CustomListView extends StatelessWidget {
  final List employees;
  const CustomListView(this.employees, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width() - 60,
      padding: const EdgeInsets.only(left: 10 , right: 10 ),
      decoration: lightBlueAccent20percentageWithRadius10Decoration,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(5),
            child: const Text(
              "data",
              style: size19BlackTextStyle,
            ),
          );
        },
      ),
    );
  }
}
