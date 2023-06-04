import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class InternalRecieve extends StatefulWidget {
  const InternalRecieve({super.key});

  @override
  State<InternalRecieve> createState() => _InternalRecieveState();
}

class _InternalRecieveState extends State<InternalRecieve> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}