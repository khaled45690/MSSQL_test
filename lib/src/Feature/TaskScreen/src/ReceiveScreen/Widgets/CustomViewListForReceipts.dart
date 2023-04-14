import 'package:flutter/material.dart';

import 'package:sql_test/src/DataTypes/ReceiptDetails.dart';
import 'package:sql_test/src/Utilities/Extentions.dart';

import '../../../../../Utilities/Style.dart';

class CustomViewListForReceipts extends StatelessWidget {
  final List<ReceiptDetails> receiptList;
  final Function(int index) deleteReceipt;
  const CustomViewListForReceipts(this.receiptList, this.deleteReceipt,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return receiptList.isEmpty
        ? const SizedBox()
        : Container(
            width: context.width() - 60,
            padding: const EdgeInsets.only(right: 10, bottom: 30),
            margin: const EdgeInsets.only(bottom: 20, top: 20),
            decoration: lightBlueAccent20percentageWithRadius10Decoration,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: receiptList.length,
              itemBuilder: (context, index) {
                String textString =
                    "${index + 1}) ${receiptList[index].F_Total_val} ${receiptList[index].F_Currency_Id!.F_CURRANCY_NAM}";
                return Container(
                  margin: const EdgeInsets.all(5),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          textString,
                          style: size19BlackTextStyle,
                        ),
                        IconButton(
                            onPressed: () => deleteReceipt(index),
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 25,
                            ))
                      ]),
                );
              },
            ),
          );
  }
}
