// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sql_test/src/Utilities/Extentions.dart';

import '../../../../../DataTypes/ReceiptDeliver.dart';
import '../../../../../DataTypes/ReceiptDeliverDetails.dart';
import '../../../../../Utilities/Style.dart';

class ReceiptDeliverViewer extends StatelessWidget {
  final List<ReceiptDeliver> receiptDeliver;
  final Function(int index) removeReceiptDeliver;
  const ReceiptDeliverViewer(this.receiptDeliver, this.removeReceiptDeliver, {super.key});

  @override
  Widget build(BuildContext context) {
    return receiptDeliver.isEmpty
        ? const SizedBox()
        : Container(
            width: context.width() - 60,
            margin: const EdgeInsets.only(top: 10, bottom: 20),
            padding: const EdgeInsets.only(right: 10, bottom: 30),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: receiptDeliver.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(bottom: 20),
                  width: context.width() - 50,
                  decoration: taskContentDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: context.width(),
                        margin: const EdgeInsets.only(right: 5, left: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "وصل ${receiptDeliver[index].F_Paper_No}",
                              style: size22BlackTextStyle,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "من ${receiptDeliver[index].F_Bank_Id_D.CustName} فرع ${receiptDeliver[index].F_Branch_Id_D.F_Branch_Name}"
                        " الى ${receiptDeliver[index].F_Bank_Id_R.CustName} فرع ${receiptDeliver[index].F_Branch_Id_R.F_Branch_Name}",
                        style: size19BlackTextStyle,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "تفاصيل الوصل:-",
                        style: size22BlackTextStyle,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: receiptDeliver[index].receiptDeliverDetails.length,
                        itemBuilder: (context, receiptDeliverDetailsIndex) {
                          ReceiptDeliverDetails receiptDeliverDetail = receiptDeliver[index].receiptDeliverDetails[receiptDeliverDetailsIndex];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "عدد ${receiptDeliverDetail.F_Bags_No} ${receiptDeliverDetail.F_Bags_No < 2 || receiptDeliverDetail.F_Bags_No > 10 ? "حقيبة" : "حقائب"},"
                                " الفئة ${receiptDeliverDetail.F_Banknote_Class == "null" ? "ورقية" : "عملات"}"
                                "${ receiptDeliverDetail.F_Banknote_Class == "null" ? ", المبلغ ${receiptDeliverDetail.F_Total_val} ${receiptDeliverDetail.currency.F_CURRANCY_NAM}" : ""}"
                                "",
                                style: size22BlackTextStyle,
                              ),
                            ],
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 100,
                          ),
                          IconButton(
                              onPressed: () => removeReceiptDeliver(index),
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 25,
                              ))
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          );
  }
}
