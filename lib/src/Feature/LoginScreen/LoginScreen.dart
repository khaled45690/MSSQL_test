import 'package:flutter/material.dart';
import 'package:sql_test/Utilities/Extentions.dart';

import '../../../Utilities/Style.dart';
import '../../../MainWidgets/CustomButton.dart';
import 'Controler/LoginScreenController.dart';
import 'Widgets/LoginTextField.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends LoginScreenController {
// user 2021
// password 2021
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: context.width(),
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("تسجيل الدخول", style: size25BlackTextStyle),
            const SizedBox(
              height: 100,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("اسم المستخدم", style: size19BlackTextStyle),
                LoginTextField(onChange , "user" , errorloginInfo["user"]),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("كلمة سر المستخدم", style: size19BlackTextStyle),
                LoginTextField(onChange ,"password" , errorloginInfo["password"]),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            CustomButton("تسجيل الدخول", 200 , login , isLoading: isLoading, isEnabled: !isLoading,),
          ],
        ),
      ),
    ));
  }
}
