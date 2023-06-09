// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sql_test/src/Feature/TaskScreen/src/DeliverTaskScreen/src/ExternalDeliverScreen/ExternalDeliverScreen.dart';
import 'package:sql_test/src/Feature/TaskScreen/src/DeliverTaskScreen/src/InternalDeliverScreen/InternalDeliverScreen.dart';
import 'package:sql_test/src/Feature/TaskScreen/src/DeliverTaskScreen/widgets/InternalAndExternalDeliverRadioButton.dart';
import 'package:sql_test/src/Utilities/Extentions.dart';
import 'package:sql_test/src/Utilities/VariableCodes.dart';

import '../../../../DataTypes/Journey.dart';



class DeliverTaskScreen extends StatelessWidget {

  final Journey journey;
  final int deliveryradioGroupValue;
  final Function(int radioGroupValue) deliveryOnRadioChangeCallback;
  const DeliverTaskScreen(this.journey, this.deliveryradioGroupValue, this.deliveryOnRadioChangeCallback, {super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 0),
      child: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              InternalAndExternalDeliverRadioButton(
                  radioGroupValue: deliveryradioGroupValue,
                  onRadioChangeCallback: deliveryOnRadioChangeCallback),
              const SizedBox(height: 20),
              deliveryradioGroupValue == InternalDelivery
                  ? InternalDeliverScreen(journey)
                  : ExternalDeliverScreen(journey),
            ],
          ),
        ),
      ),
    );
  }
}
