// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/material.dart';

// ignore: camel_case_extensions
extension customContext on BuildContext {
  double width() => MediaQuery.of(this).size.width;
  double height() => MediaQuery.of(this).size.height;

  navigateTo(Widget destination) => Navigator.push(
        this,
        MaterialPageRoute(builder: (context) => destination),
      );
  popupAndNavigateTo(Widget destination) {
    Navigator.pop(this);
    Navigator.push(
      this,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  popupAllAndNavigateTo(String destinationName) {
    Timer(const Duration(milliseconds: 50), () {
      Navigator.popUntil(this, ModalRoute.withName(destinationName));
    });

    Timer(const Duration(milliseconds: 50), () {
      Navigator.pop(
        this,
      );
    });
    Timer(const Duration(milliseconds: 50), () {
      Navigator.pushNamed(
        this,
        destinationName,
      );
    });
  }

  popUp() {
    Navigator.pop(
      this,
    );
  }

  popupAndNavigateToWithName(String destinationName) {
    Navigator.pop(this);
    Navigator.pushNamed(
      this,
      destinationName,
    );
  }

  snackBar(text, {Color color = Colors.black54}) =>
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 6000),
          backgroundColor: color,
          padding: const EdgeInsets.all(20),
          elevation: 3,
          showCloseIcon: true,
          closeIconColor: Colors.red,
          content: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      );
}
