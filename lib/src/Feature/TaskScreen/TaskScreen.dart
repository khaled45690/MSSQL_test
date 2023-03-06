import 'package:flutter/material.dart';
import 'package:sql_test/Utilities/Extentions.dart';
import 'package:sql_test/src/Feature/TaskScreen/src/ReceiveScreen/ReceiveScreen.dart';

import '../../../MainWidgets/CustomButton.dart';
import '../../../Utilities/Colors.dart';
import '../../../Utilities/Style.dart';
import 'Controller/TaskScreenController.dart';
import 'Widgets/ReceiveAndDeliverRadioGroup.dart';
import 'Widgets/TaskCard.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends TaskScreenController {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: mainBlue),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          width: context.width(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              ReceiveAndDeliverRadioGroup(
                  radioGroupValue: radioGroupValue,
                  onRadioChangeCallback: onRadioChangeCallback),
              const SizedBox(height: 30),
              ReceiveScreen(),
              const TaskCard("82", true),
              const TaskCard("928", false),
              const SizedBox(height: 30),
              const SizedBox(height: 30),
              CustomButton("اضف مهمة", 250, () {}),
            ],
          ),
        ),
      ),
    );
  }
}
