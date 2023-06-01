// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sql_test/src/Utilities/Extentions.dart';

import '../Utilities/Style.dart';
import 'SearchTextField.dart';

String? searchString;

class DropDownWithSearch extends StatelessWidget {
  final List<String> list;
  final String? text;
  final List<String> Function(List<String> list, String? search) onTextChange;
  final Function(String item) onItemChange;
  const DropDownWithSearch(
      this.list, this.onTextChange, this.onItemChange, this.text,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: key,
      onTap: () {
        Scaffold.of(context).showBottomSheet<void>(
          clipBehavior: Clip.antiAlias,
          elevation: 3,
          enableDrag: false,
          (BuildContext context) {
            return StatefulBuilder(builder: (BuildContext context,
                StateSetter setState /*You can rename this!*/) {
              return Container(
                decoration: noColor50RadiusWithShadowDecoration,
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
                            child: SearchTextField((da, value) {
                              setState(() => {searchString = value});
                            }),
                          ),
                          Container(
                            margin: const EdgeInsets.all(60),
                            width: context.width(),
                            height: context.width() - 50,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount:
                                  onTextChange(list, searchString).length,
                              // physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (listContext, index) {
                                return MaterialButton(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0))),
                                  splashColor: Colors.lightBlue.withOpacity(.7),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    onItemChange(onTextChange(
                                        list, searchString)[index]);
                                    searchString = null;
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      onTextChange(list, searchString)[index],
                                      textDirection: TextDirection.rtl,
                                      style: favoriteDescriptionTextStyle,
                                    ),
                                  ),
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
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: dropDownDecoration,
        child: Text(
          text ?? "please choose item",
          style: cartPartTwoTextStyle,
        ),
      ),
    );
  }
}

