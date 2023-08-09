// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sql_test/src/DataTypes/Receipt.dart';
import 'package:sql_test/src/Utilities/Extentions.dart';

import '../../../Utilities/Style.dart';
import '../src/ReceiveScreen/ExternalReceive/src/ExternalReceiveScreen.dart';

class ReceiptCard extends StatelessWidget {
  final Receipt receipt;
  final bool isDone;
  final bool isEditable;
  final Function(Receipt receiptParameter) parsedFunction, saveReceiptInJouerny;
  const ReceiptCard(this.receipt, this.isDone, {super.key, required this.parsedFunction, this.isEditable = true, required this.saveReceiptInJouerny});

  @override
  Widget build(BuildContext context) {
    debugPrint("receipt");
    debugPrint(receipt.isDeliveredToAnotherDriver.toString());
    return InkWell(
      onTap: () => isEditable ? context.navigateTo(ExternalReceiveScreen(receipt, parsedFunction, saveReceiptInJouerny, isDone)) : null,
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(bottom: 20),
        width: context.width() - 50,
        decoration: taskContentDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Text(
              "اجمالى الاموال :- ${receipt.F_totalAmount_EGP} جنية مصرى",
              style: size19BlackTextStyle,
            ),
            Text(
              "اجمالى العملات المعدنية :- ${receipt.F_Coin_Tot} جنية مصرى",
              style: size19BlackTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
