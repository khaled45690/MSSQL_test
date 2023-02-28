import 'package:flutter/material.dart';

import '../../../../MainWidgets/CustomTextField.dart';
import '../../../../Utilities/Style.dart';

class AddEmployeeByWriting extends StatelessWidget {
  final bool isLoading;
  const AddEmployeeByWriting( this.isLoading , {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
      child: Row(
        children: [
          CustomTextField((da, dasda) {}, 250),
          InkWell(
            child: Container(
              margin: const EdgeInsets.only(right: 10, bottom: 10),
              decoration: isLoading
                  ? greyColor50RadiusWithShadowDecoration
                  : mainBlueColor50RadiusWithShadowDecoration,
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
