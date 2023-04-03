import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sql_test/DataTypes/CrewMember.dart';
import 'package:sql_test/DataTypes/ReceiptDeliver.dart';
import 'package:sql_test/Utilities/Extentions.dart';

import '../../../../../../Utilities/Style.dart';

class ReceiptDeliverListView extends StatelessWidget {
  final List<ReceiptDeliver> receiptDeliver;
  final Function(int index) removeReceiptDeliver;
  const ReceiptDeliverListView(this.receiptDeliver, this.removeReceiptDeliver,{super.key});

  @override
  Widget build(BuildContext context) {
    return receiptDeliver.isEmpty
        ? const SizedBox()
        : Container(
            width: context.width() - 60,
            margin: const EdgeInsets.only(top: 10 , bottom: 20),
            padding: const EdgeInsets.only(right: 10, bottom: 30),
            decoration: lightBlueAccent20percentageWithRadius10Decoration,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: receiptDeliver.length,
              itemBuilder: (context, index) {
                String textString =
                    "${index + 1}) ${receiptDeliver[index].F_Paper_No}";
                return Container(
                  margin: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Text(
                      textString,
                      style: size19BlackTextStyle,
                    ),
                   IconButton(onPressed: ()=>removeReceiptDeliver(index), icon: const Icon(Icons.delete , color: Colors.red , size: 25,))
                  ]),
                );
              },
            ),
          );
  }
}