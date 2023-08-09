// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sql_test/src/DataTypes/Currency.dart';
import 'package:sql_test/src/Utilities/Extentions.dart';
import 'package:sql_test/src/Utilities/colors.dart';

import '../../Utilities/Style.dart';
import '../SearchTextField.dart';



Map<int, Color> color = {
  50: Colors.white,
  100: Colors.white,
  200: Colors.white,
};

searchButtonSheetForCurrency(BuildContext context, List<Currency> currencyList,
    Function(Currency currency ) onSelectCurrencyFunc ) {
  Scaffold.of(context).showBottomSheet<void>(
    clipBehavior: Clip.antiAlias,
    elevation: 3,
    enableDrag: false,
    (BuildContext context) {
      return CustomSearchWithFilterWidget(currencyList, onSelectCurrencyFunc);
    },
  );
}

class CustomSearchWithFilterWidget extends StatefulWidget {
  final List<Currency> currencyList;
  final Function(Currency currency ) onSelectCurrencyFunc;
  const CustomSearchWithFilterWidget(
      this.currencyList, this.onSelectCurrencyFunc,
      {super.key});

  @override
  State<CustomSearchWithFilterWidget> createState() =>
      _CustomSearchWithFilterWidgetState();
}

class _CustomSearchWithFilterWidgetState
    extends State<CustomSearchWithFilterWidget> {
  late List<Currency> currencyList;
  bool isId = false;
  @override
  void initState() {

    super.initState();
    currencyList = widget.currencyList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: mainColor50RadiusWithShadowDecoration,

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
                    itemCount: currencyList.length,
                    itemBuilder: (listContext, index) {
                      return MaterialButton(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        splashColor: Colors.lightBlue.withOpacity(.7),
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onSelectCurrencyFunc(currencyList[index]);
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
                                        ? currencyList[index].F_CURRANCY_ID.toString()
                                        : currencyList[index].F_CURRANCY_NAM,
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
    List<Currency> filter = [];
    if (value == "" && value == " ") {
      currencyList = widget.currencyList;
      setState(() {});
    }
    for (var currency in widget.currencyList) {
      if (!isId) {
        if (value.length < currency.F_CURRANCY_NAM.length) {
          if (currency.F_CURRANCY_NAM.substring(0, value.length) == value) {
            filter.add(currency);
          }
        }
      } else {
        if (value.length <= currency.F_CURRANCY_ID.toString().length) {
          if (currency.F_CURRANCY_ID.toString().substring(0, value.length) == value) {
            filter.add(currency);
          }
        }
      }
    }

    currencyList = filter;
    setState(() {});
  }
}
