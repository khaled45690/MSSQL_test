// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sql_test/src/Utilities/Extentions.dart';

import '../../../MainWidgets/CustomButton.dart';
import '../../../DataTypes/Journey.dart';
import '../../../Utilities/Strings.dart';
import '../../../Utilities/Style.dart';
import '../../TaskScreen/TaskScreen.dart';

class JourneyCard extends StatelessWidget {
  final Journey journey;
  final Function()? reOpenLastJourney;
  final Function() updateDataBase;
  const JourneyCard(this.journey, this.reOpenLastJourney, this.updateDataBase,{super.key});

  @override
  Widget build(BuildContext context) {
    DateTime startTime = DateTime.parse(journey.F_Sdate);
    return InkWell(
      onTap: () => context.navigateTo(TaskScreen(journey , updateDataBase)),
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 30),
        width: context.width() - 60,
        decoration: BagsContentDecoration,
        child: Column(
          children: [
            Text(
              "الرحلة ${journey.F_Id}",
              style: size22BlackTextStyle,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "تاريخ البداية  ${startTime.month}/${startTime.day}",
                  style: size19BlackTextStyle,
                ),
                if (journey.isFinished)
                  Text(
                    "تاريخ النهاية ${DateTime.parse(journey.F_Edate!).month}/${DateTime.parse(journey.F_Edate!).day}",
                    style: size19BlackTextStyle,
                  ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      "حالة الرحلة: ",
                      style: size19BlackTextStyle,
                    ),
                    journey.isFinished
                        ? Text(
                            "مغلق ",
                            style: size19RedTextStyle,
                          )
                        : Text(
                            "مفتوح ",
                            style: size19GreenTextStyle,
                          ),
                  ],
                ),
                reOpenLastJourney == null ? const SizedBox() : CustomButton(reOpenLastJourneyButtonString, 170, reOpenLastJourney!),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


// reOpenLastJourneyButtonString