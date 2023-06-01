// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRCodeDetection extends StatelessWidget {
  final MobileScannerController cameraController;
  final double height;
  final Function(BarcodeCapture capture) onCapture ;

  const QRCodeDetection(this.height, this.onCapture,this.cameraController, {super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: height,
      width: 300,
      margin: const EdgeInsets.only(bottom: 10, top: 10),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: MobileScanner(
          // fit: BoxFit.contain,

          controller: cameraController,
          onDetect: (barCodes) => onCapture(barCodes),
        ),
      ),
    );
  }
}
