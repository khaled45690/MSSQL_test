import 'package:flutter/material.dart';

import '../../../../Utilities/Style.dart';

class AddingCheckHeaderAndButton extends StatelessWidget {
  final bool isLoading;
  final Function(BuildContext context) addChecks;
  const AddingCheckHeaderAndButton(this.isLoading , this.addChecks, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          const Text("الايصالات المرجو تسليمها", style: size22BlackTextStyle),
          InkWell(
            onTap: isLoading ? null : () => addChecks(context),
            child: Container(
              margin: const EdgeInsets.only(right: 10, bottom: 10),
              decoration: isLoading
                  ? greyColor50RadiusWithShadowDecoration
                  : mainBlueColor50RadiusWithShadowDecoration,
              child: const Icon(Icons.add, color: Colors.white, size: 30),
            ),
          ),
          isLoading
              ? Container(
                  margin: const EdgeInsets.only(right: 10, bottom: 10),
                  child: Image.asset(
                    "assets/images/loading.gif",
                    width: 30,
                  ))
              : Container(),
        ],
      ),
    );
  }
}
