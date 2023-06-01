
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sql_test/src/Utilities/Extentions.dart';

import '../../../DataTypes/User.dart';
import '../../../Utilities/Prefs.dart';
import '../../../Utilities/Strings.dart';
import '../AuthScreen.dart';

abstract class AuthScreenController extends State<AuthScreen> {
  Map loginInfo = {
    "user": null,
    "password": null,
  };
  Map errorloginInfo = {};
  bool isLoading = false;
  onChange(String value, String variableName) {
    loginInfo[variableName] = value;
    errorloginInfo[variableName] = null;
    setState(() {});
  }

  login() {
    if (_checkNullValues()) return;
    String? usersDataString = Prefs.getString(driversFromLocaleDataBase);

    if (usersDataString == null) return context.snackBar(firstTimeDataUpdate);
    isLoading = true;
    setState(() {});
    List<User> usersData = User.fromJsonStringListToUserList(usersDataString);
    User? user;

    for (var userData in usersData) {
      if (userData.F_Login == int.parse(loginInfo["user"]) &&
          userData.F_Password == int.parse(loginInfo["password"])) {
        user = userData;
      }
    }

    if (user == null) {
      isLoading = false;
      setState(() {});
      return context.snackBar(wrongLoginInfo);
    }

    user.dateOfLogin = DateTime.now().toString();
    Prefs.setString(loginUserFromLocaleDataBase, user.toJsonString());
    context.popupAndNavigateToWithName("/JourneyScreen");
  }

  bool _checkNullValues() {
    bool isNull = false;
    loginInfo.forEach((key, value) {
      if (loginInfo[key] == null) {
        isNull = true;
        errorloginInfo[key] = "من فضلك ادخل هذا الحقل";
      }
    });
    setState(() {});
    return isNull;
  }
}
