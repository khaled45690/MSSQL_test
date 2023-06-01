// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../MainWidgets/CustomButton.dart';
import '../../../StateManagement/InternetState/InternetStateHandler.dart';

class JourneyButtons extends StatelessWidget {
  final bool isStartEnabled, isEndEnabled;
  final Function() startNewJourney, endTheJourney;
  const JourneyButtons({super.key, required this.isStartEnabled, required this.isEndEnabled, required this.startNewJourney, required this.endTheJourney});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CustomButton(
          "ابدا رحلة",
          150,
          startNewJourney,
          isEnabled: isStartEnabled,
        ),
        StreamBuilder(
            stream: InternetConnectionCubit.isConnectedToInternet.stream,
            builder:
                (BuildContext context, AsyncSnapshot<bool> isConnectedStream) {
              debugPrint(InternetConnectionCubit.isConnected.toString());
              return CircleAvatar(
                  radius: 20,
                  backgroundColor: InternetConnectionCubit.isConnected
                      ? Colors.green.shade800
                      : Colors.red.shade800);
            }),
        CustomButton("انهاء الرحلة", 150, endTheJourney,
            isEnabled: isEndEnabled),
      ],
    );
  }
}
