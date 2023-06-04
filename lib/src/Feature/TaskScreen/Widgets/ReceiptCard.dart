// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sql_test/src/DataTypes/Receipt.dart';
import 'package:sql_test/src/Utilities/Extentions.dart';

import '../../../Utilities/Style.dart';
import '../src/ReceiveScreen/ExternalReceive/src/ExternalReceiveScreen.dart';

class ReceiptCard extends StatelessWidget {
  final Receipt receipt;
  final bool isDone;
  final Function(Receipt receiptParameter) parsedFunction, saveReceiptInJouerny;
  const ReceiptCard(this.receipt, this.isDone,
      {super.key,
      required this.parsedFunction,
      required this.saveReceiptInJouerny});

  @override
  Widget build(BuildContext context) {
    debugPrint("receipt");
    debugPrint(receipt.isSavedInDatabase.toString());
    return InkWell(
      onTap: () => context.navigateTo(ExternalReceiveScreen(
          receipt, parsedFunction, saveReceiptInJouerny, isDone)),
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(bottom: 20),
        width: context.width() - 50,
        decoration: taskContentDecoration,
        child: Column(
          children: [
            Text(
              "وصل ${receipt.F_Paper_No ?? "فارغ"}",
              style: size22BlackTextStyle,
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "تاريخ الوصل  ${DateTime.now().day}/${DateTime.now().month}",
                  style: size19BlackTextStyle,
                ),
                Row(
                  children: [
                    const Text(
                      "حالة الوصل: ",
                      style: size19BlackTextStyle,
                    ),
                    isDone
                        ? Text(
                            "حفظ ",
                            style: size19GreenTextStyle,
                          )
                        : Text(
                            "لم يحفظ ",
                            style: size19RedTextStyle,
                          ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
