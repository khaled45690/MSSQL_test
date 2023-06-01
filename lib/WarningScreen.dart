import 'package:flutter/material.dart';

import 'src/Utilities/Style.dart';

class WarningScreen extends StatelessWidget {
  const WarningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("من فضلك قم بالتواصل مع \nخالد سعد عباس ",
            textAlign: TextAlign.center, style: moneyWarningTextStyle),
      ),
    );
  }
}
