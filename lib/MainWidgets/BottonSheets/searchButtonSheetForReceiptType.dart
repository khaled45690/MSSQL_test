
import 'package:flutter/material.dart';
import 'package:sql_test/DataTypes/ReceiptType.dart';
import 'package:sql_test/Utilities/Extentions.dart';
import 'package:sql_test/Utilities/colors.dart';

import '../../Utilities/Style.dart';
import '../SearchTextField.dart';

Map<int, Color> color = {
  50: Colors.white,
  100: Colors.white,
  200: Colors.white,
};

searchButtonSheetForReceiptType(BuildContext context, List<ReceiptType> receiptTypeList,
    Function(ReceiptType receiptTypeList) onSelectCustomerFunc ) {
  Scaffold.of(context).showBottomSheet<void>(
    clipBehavior: Clip.antiAlias,
    elevation: 3,
    enableDrag: false,
    (BuildContext context) {
      return CustomSearchWithFilterWidget(receiptTypeList, onSelectCustomerFunc);
    },
  );
}

class CustomSearchWithFilterWidget extends StatefulWidget {
  final List<ReceiptType> receiptTypeList;
  final Function(ReceiptType receiptTypeList) onSelectCustomerFunc;
  const CustomSearchWithFilterWidget(
      this.receiptTypeList, this.onSelectCustomerFunc,
      {super.key});

  @override
  State<CustomSearchWithFilterWidget> createState() =>
      _CustomSearchWithFilterWidgetState();
}

class _CustomSearchWithFilterWidgetState
    extends State<CustomSearchWithFilterWidget> {
  late List<ReceiptType> receiptTypeList;
  bool isId = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    receiptTypeList = widget.receiptTypeList;
  }

  @override
  Widget build(BuildContext context) {
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
                  child: SearchTextField(onChange, isNumber: isId),
                ),
                Container(
                  width: double.maxFinite,
                  margin: const EdgeInsets.only(top: 60),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          isId = false;
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            Checkbox(
                                checkColor: Colors.white,
                                activeColor: mainBlue,
                                side: const BorderSide(color: Colors.white),
                                value: isId ? false : true,
                                onChanged: (isChecked) {
                                  isId = false;
                                  setState(() {});
                                }),
                            const Text(
                              "بالاسم",
                              textDirection: TextDirection.rtl,
                              style: favoriteDescriptionTextStyle,
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          isId = true;
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            Checkbox(
                                checkColor: Colors.white,
                                activeColor: mainBlue,
                                side: const BorderSide(color: Colors.white),
                                value: isId ? true : false,
                                onChanged: (isChecked) {
                                  isId = true;
                                  setState(() {});
                                }),
                            const Text(
                              "بالID",
                              textDirection: TextDirection.rtl,
                              style: favoriteDescriptionTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 0, top: 140),
                  width: context.width() - 50,
                  height: context.width() - 90,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: receiptTypeList.length,
                    itemBuilder: (listContext, index) {
                      return MaterialButton(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        splashColor: Colors.lightBlue.withOpacity(.7),
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onSelectCustomerFunc(receiptTypeList[index]);
                        },
                        child: Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            width: double.infinity,
                            padding: const EdgeInsets.all(0),
                            child: Row(
                              textDirection: TextDirection.rtl,
                              children: [
                                Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: mainBlue,
                                    side: const BorderSide(color: Colors.white),
                                    value: false,
                                    onChanged: (isChecked) {}),
                                SizedBox(
                                  width: 170,
                                  child: Text(
                                    isId
                                        ? receiptTypeList[index].receiptTypeNumber.toString()
                                        : receiptTypeList[index].receiptTypeName,
                                    overflow: TextOverflow.visible,
                                    textDirection: TextDirection.rtl,
                                    style: favoriteDescriptionTextStyle,
                                  ),
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
  }

  onChange(String variableName, String value) {
    List<ReceiptType> filter = [];
    if (value == "" && value == " ") {
      receiptTypeList = widget.receiptTypeList;
      setState(() {});
    }
    for (var customer in widget.receiptTypeList) {
      if (!isId) {
        if (value.length < customer.receiptTypeName.length) {
          if (customer.receiptTypeName.substring(0, value.length) == value) {
            filter.add(customer);
          }
        }
      } else {
        if (value.length <= customer.receiptTypeNumber.toString().length) {
          if (customer.receiptTypeNumber.toString().substring(0, value.length) == value) {
            filter.add(customer);
          }
        }
      }
    }

    receiptTypeList = filter;
    setState(() {});
  }
}

