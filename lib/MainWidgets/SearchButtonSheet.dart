import 'package:flutter/material.dart';
import 'package:sql_test/Utilities/Extentions.dart';
import 'package:sql_test/Utilities/colors.dart';

import '../Utilities/Style.dart';
import 'SearchTextField.dart';

Map<int, Color> color = {
  50: Colors.white,
  100: Colors.white,
  200: Colors.white,
};

searchButtonSheet(BuildContext context) {
  Scaffold.of(context).showBottomSheet<void>(
    clipBehavior: Clip.antiAlias,
    elevation: 3,
    enableDrag: false,
    (BuildContext context) {
      return StatefulBuilder(builder: (BuildContext context,
          StateSetter setState /*You can rename this!*/) {
        return Container(
          decoration: mainColor50RadiusWithShadowDecoration,
          height: 500,
          width: context.width(),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 30,
                ),
                Stack(
                  children: [
                    Center(
                      child: SearchTextField((da, value) {}),
                    ),
                    Container(
                      margin: const EdgeInsets.all(60),
                      width: context.width() - 100,
                      height: context.width() - 50,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: 3,
                        itemBuilder: (listContext, index) {
                          return MaterialButton(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                            splashColor: Colors.lightBlue.withOpacity(.7),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(0),
                                child: Row(
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    Checkbox(
                                        checkColor: Colors.white,
                                        activeColor: mainBlue,
                                        side: BorderSide(color: Colors.white),
                                        value: false,
                                        onChanged: (isChecked) {}),
                                    const Text(
                                      "onTextChange",
                                      textDirection: TextDirection.rtl,
                                      style: favoriteDescriptionTextStyle,
                                    ),
                                  ],
                                )),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      });
    },
  );
}
