import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sql_test/Utilities/Extentions.dart';
import 'package:sql_test/src/Feature/DeliveryData/DeliveryDataScreen.dart';

import '../DeliveryData/Widget/AddButton.dart';

class StarterScreen extends StatelessWidget {
  const StarterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        textDirection: TextDirection.rtl,
        children: [
          AddButton("استلام", () => context.navigateTo(const DeliveryDataScreen(true))),
          AddButton("تسليم", () => context.navigateTo( const DeliveryDataScreen(false)))
        ],
      ),
    ),
    );
  }
}
