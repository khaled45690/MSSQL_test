import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sql_test/src/Utilities/Extentions.dart';



class ImageViewer extends StatelessWidget {
    final Uint8List image;
  const ImageViewer(this.image,{super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: context.width(),
        height: context.height(),
        child: Image.memory(image , fit: BoxFit.fill),
      ),
    );
  }
}