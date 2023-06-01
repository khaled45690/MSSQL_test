// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';

import 'Colors.dart';

// Text Style
const textfieldHintStyle = TextStyle(
  color: Colors.grey,
);

const TextStyle authTitleStyle =
    TextStyle(color: mainOrange, fontSize: 25, fontWeight: FontWeight.bold);
const TextStyle authDescriptionStyle =
    TextStyle(fontSize: 17, fontWeight: FontWeight.w600, letterSpacing: 1);
const TextStyle textFieldUpperTextStyle =
    TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 1);

const TextStyle authsecondPartTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 1,
    color: mainOrange,
    decoration: TextDecoration.underline,
    decorationThickness: 25,
    decorationColor: mainOrange);
const TextStyle authButtonTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5);

const TextStyle itemViewerUpperTextStyle =
    TextStyle(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0);
const TextStyle itemViewerDescriptionTextStyle =
    TextStyle(fontSize: 18, fontWeight: FontWeight.w500, letterSpacing: 0.6);
const TextStyle itemViewerPriceTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: mainBlue);
const TextStyle moneyWarningTextStyle = TextStyle(
    fontSize: 35,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
    color: mainBlue);
const TextStyle favoriteDescriptionTextStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    color: Colors.white);
const TextStyle favoritePriceTextStyle = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.w600,
    letterSpacing: 1,
    color: mainBlue);

const TextStyle favoriteButtonTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4);

const TextStyle productTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4);

const TextStyle orangeProductTextStyle = TextStyle(
    color: mainOrange,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4);

const TextStyle productPriceTextStyle = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: mainBlue);

const TextStyle cartPartTwoTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.4);

const TextStyle cartPartOneTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    color: mainBlue);

const TextStyle couponTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3);

const couponTextfieldHintStyle = TextStyle(color: Colors.black, fontSize: 14);

const TextStyle size19BlackTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 19,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4);

TextStyle size19RedTextStyle = TextStyle(
    color: Colors.red.shade900,
    fontSize: 19,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4);

TextStyle size19GreenTextStyle = TextStyle(
    color: Colors.green.shade900,
    fontSize: 19,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4);
const TextStyle size22BlackTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4);
const TextStyle size25BlackTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 25,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4);

// Decoration Style------------------------->>>>>>>>>>>>>>>>>

const BoxDecoration noColor50RadiusWithShadowDecoration = BoxDecoration(
  boxShadow: [
    BoxShadow(
      color: Colors.black,
      spreadRadius: 2,
      blurRadius: 100,
      offset: Offset(0, 60), // changes position of shadow
    ),
  ],
  borderRadius: BorderRadius.all(Radius.circular(50)),
);

BoxDecoration mainColor50RadiusWithShadowDecoration = BoxDecoration(
  boxShadow: const [
    BoxShadow(
      color: Colors.black,
      spreadRadius: 2,
      blurRadius: 100,
      offset: Offset(0, 60), // changes position of shadow
    ),
  ],
  color: mainBlue.withOpacity(0.3),
  borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(50), topRight: Radius.circular(50)),
);

const BoxDecoration mainBlueColor50RadiusWithShadowDecoration = BoxDecoration(
  boxShadow: [
    BoxShadow(
      color: Colors.blueGrey,
      spreadRadius: 2,
      blurRadius: 5,
      offset: Offset(0, 0), // changes position of shadow
    ),
  ],
  color: mainBlue,
  borderRadius: BorderRadius.all(Radius.circular(50)),
);

const BoxDecoration greyColor50RadiusWithShadowDecoration = BoxDecoration(
  boxShadow: [
    BoxShadow(
      color: Colors.blueGrey,
      spreadRadius: 2,
      blurRadius: 5,
      offset: Offset(0, 0), // changes position of shadow
    ),
  ],
  color: Colors.grey,
  borderRadius: BorderRadius.all(Radius.circular(50)),
);

const BoxDecoration noColor50RadiusDecoration = BoxDecoration(
  borderRadius: BorderRadius.all(Radius.circular(50)),
);

BoxDecoration dropDownDecoration = BoxDecoration(
  borderRadius: const BorderRadius.all(Radius.circular(20)),
  border: Border.all(
    color: Colors.black,
    width: 1,
  ),
  color: Colors.lightBlueAccent.withOpacity(0.2),
);

BoxDecoration lightBlueAccent20percentageWithRadius10Decoration = BoxDecoration(
  borderRadius: const BorderRadius.all(Radius.circular(10)),
  border: Border.all(
    color: Colors.black,
    width: 1,
  ),
  boxShadow: [
    BoxShadow(
      color: Colors.lightBlueAccent.withOpacity(0.5),
      spreadRadius: 3,
      blurRadius: 3,
      offset: const Offset(0, 3), // changes position of shadow
    ),
  ],
  color: Colors.lightBlueAccent.withOpacity(0.2),
);
BoxDecoration BagsContentDecoration = BoxDecoration(
  borderRadius: const BorderRadius.all(Radius.circular(10)),
  border: Border.all(
    color: Colors.black,
    width: 1,
  ),
  color: mainBlue.withOpacity(0.4),
);

BoxDecoration taskContentDecoration = BoxDecoration(
  borderRadius: const BorderRadius.all(Radius.circular(10)),
  border: Border.all(
    color: Colors.black,
    width: 1,
  ),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 5,
      blurRadius: 7,
      offset: const Offset(0, 3), // changes position of shadow
    ),
  ],
  color: mainBlue.withOpacity(0.4),
);


BoxDecoration decorationWithBorder = BoxDecoration(
  borderRadius: const BorderRadius.all(Radius.circular(10)),
  border: Border.all(
    color: Colors.black,
    width: 1,
  ),
);
