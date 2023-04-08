import 'package:flutter/material.dart';

import '../../../../../MainWidgets/CustomTextField.dart';
import '../../../../../Utilities/Style.dart';

class AddEmployeeByWriting extends StatelessWidget {
  final bool isLoading , isEnabled;
    final Function( String value) onChange;
    final Function()? onTap;
  const AddEmployeeByWriting( this.isLoading , this.isEnabled ,this.onChange, {super.key , this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
      child: Row(
        children: [
          CustomTextField(onChange, 250 , isNumber: true,),
          InkWell(
            onTap: isEnabled ? onTap : null,
            child: Container(
              margin: const EdgeInsets.only(right: 10, bottom: 10),
              decoration: isEnabled
                  ? mainBlueColor50RadiusWithShadowDecoration
                  : greyColor50RadiusWithShadowDecoration,
              child: const Icon(Icons.add, color: Colors.white, size: 30),
            ),
          ),
          isLoading ? Container(
              margin: const EdgeInsets.only(right: 10, bottom: 10),
              child: Image.asset(
                "assets/images/loading.gif",
                width: 30,
              )) : Container(),
        ],
      ),
    );
  }
}
