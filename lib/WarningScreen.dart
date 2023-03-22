import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'Utilities/Style.dart';

class WarningScreen extends StatelessWidget {
  const WarningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("من فضلك قم بدفع ما عليك من مال \nخالد سعد عباس ",
            textAlign: TextAlign.center, style: moneyWarningTextStyle),
      ),
    );
  }
}
