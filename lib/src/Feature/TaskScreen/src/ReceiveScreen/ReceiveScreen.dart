import 'package:flutter/material.dart';

import '../../../../../MainWidgets/QRCodeDetection.dart';
import '../../Controller/TaskScreenController.dart';
import 'Controller/ReceiveScreenController.dart';

class ReceiveScreen extends StatefulWidget {
  const ReceiveScreen({super.key});

  @override
  State<ReceiveScreen> createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends ReceiveScreenController {


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: () {
        TaskScreenController;
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
             addingEmployeeButton(),
             QRCodeDetection(height, cameraController),
          ],
        ),
      ),
    );
  }
}
