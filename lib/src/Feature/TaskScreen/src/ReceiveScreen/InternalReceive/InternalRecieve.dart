

import 'package:flutter/material.dart';

import '../../../../../DataTypes/Receipt.dart';

class InternalReceive extends StatefulWidget {
    final List<Receipt> receipts;
  final Function(
          Receipt receiptParameter, int receiptIndex, bool isFinalyEdited)
      editReceiptInJouerny;
  const InternalReceive({super.key , required this.receipts , required this.editReceiptInJouerny});

  @override
  State<InternalReceive> createState() => _InternalReceiveState();
}

class _InternalReceiveState extends State<InternalReceive> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}