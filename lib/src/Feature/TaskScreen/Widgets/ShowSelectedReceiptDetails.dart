// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sql_test/src/DataTypes/Receipt.dart';
import 'package:sql_test/src/Utilities/Extentions.dart';

import '../../../Utilities/Style.dart';
import '../src/ReceiveScreen/ExternalReceive/src/ExternalReceiveScreen.dart';

class ShowSelectedReceiptDetails extends StatelessWidget {
  final Receipt receipt;
  final bool isDone;
  final bool isEditable;
  final Function(Receipt receiptParameter) parsedFunction, saveReceiptInJouerny;
  const ShowSelectedReceiptDetails(this.receipt, this.isDone, {super.key, required this.parsedFunction, this.isEditable = true, required this.saveReceiptInJouerny});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => isEditable ? context.navigateTo(ExternalReceiveScreen(receipt, parsedFunction, saveReceiptInJouerny, isDone)) : null,
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(bottom: 20),
        width: context.width() - 50,
        decoration: taskContentDecoration,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 5, left: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "وصل ${receipt.F_Paper_No ?? "فارغ"}",
                    style: size22BlackTextStyle,
                  ),
                  isEditable
                      ? Text(
                          "قابل للتعديل",
                          style: size19GreenTextStyle,
                        )
                      : Text(
                          "غير قابل للتعديل",
                          style: size19RedTextStyle,
                        ),
                ],
              ),
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
