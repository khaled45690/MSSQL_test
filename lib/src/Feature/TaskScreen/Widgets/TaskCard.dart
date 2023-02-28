import 'package:flutter/material.dart';
import 'package:sql_test/Utilities/Extentions.dart';

import '../../../../Utilities/Style.dart';
import '../../DeliverScreen/DeliverScreen.dart';

class TaskCard extends StatelessWidget {
  final String name;
  final bool isDone;
  const TaskCard(this.name, this.isDone ,{super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=> context.navigateTo(const DeliverScreen()),
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 30),
        width: context.width() - 50,
        decoration: BagsContentDecoration,
        child: Column(
          children: [
            Text(
              "المهمة $name",
              style: size22BlackTextStyle,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "تاريخ البداية  ${DateTime.now().day}/${DateTime.now().month}",
                  style: size19BlackTextStyle,
                ),
                isDone ? Text(
                  "تاريخ النهاية ${DateTime.now().day}/${DateTime.now().month}",
                  style: size19BlackTextStyle,
                ) : Container(),
              ],
            ),
                      const SizedBox(
              height: 20,
            ),
             Row(
              children: [
                const Text(
                  "حالة الرحلة: ",
                  style: size19BlackTextStyle,
                ),
                isDone ? Text(
                  "تسلم ",
                  style: size19GreenTextStyle,
                ): Text(
                  "معلق ",
                  style: size19RedTextStyle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
