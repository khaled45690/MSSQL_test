
import 'package:flutter/material.dart';

// ignore: camel_case_extensions
extension customContext on BuildContext {
  double width() => MediaQuery.of(this).size.width;
  double height() => MediaQuery.of(this).size.height;

  navigateTo(Widget destination) => Navigator.push(
        this,
        MaterialPageRoute(builder: (context) => destination),
      );

  snackBar(text) => ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          content: Text(
            text,
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
}