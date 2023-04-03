
import 'package:flutter/material.dart';
import 'package:sql_test/DataTypes/ReceiptDeliver.dart';
import 'package:sql_test/Utilities/Extentions.dart';
import 'package:sql_test/Utilities/colors.dart';

import '../../DataTypes/ReceiptDeliver.dart';
import '../../Utilities/Style.dart';
import '../SearchTextField.dart';

Map<int, Color> color = {
  50: Colors.white,
  100: Colors.white,
  200: Colors.white,
};

searchButtonSheetForReceiptDeliverType(BuildContext context, List<ReceiptDeliver> receiptDeliverList,
    Function(ReceiptDeliver receiptDeliverList) onSelectCustomerFunc ) {
  Scaffold.of(context).showBottomSheet<void>(
    clipBehavior: Clip.antiAlias,
    elevation: 3,
    enableDrag: false,
    (BuildContext context) {
      return CustomSearchWithFilterWidget(receiptDeliverList, onSelectCustomerFunc);
    },
  );
}

class CustomSearchWithFilterWidget extends StatefulWidget {
  final List<ReceiptDeliver> receiptDeliverList;
  final Function(ReceiptDeliver receiptDeliverList) onSelectCustomerFunc;
  const CustomSearchWithFilterWidget(
      this.receiptDeliverList, this.onSelectCustomerFunc,
      {super.key});

  @override
  State<CustomSearchWithFilterWidget> createState() =>
      _CustomSearchWithFilterWidgetState();
}

class _CustomSearchWithFilterWidgetState
    extends State<CustomSearchWithFilterWidget> {
  late List<ReceiptDeliver> ReceiptDeliverList;
  bool isId = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ReceiptDeliverList = widget.receiptDeliverList;
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
                  margin: const EdgeInsets.only(right: 0, top: 140),
                  width: context.width() - 50,
                  height: context.width() - 90,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: ReceiptDeliverList.length,
                    itemBuilder: (listContext, index) {
                      return MaterialButton(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        splashColor: Colors.lightBlue.withOpacity(.7),
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onSelectCustomerFunc(ReceiptDeliverList[index]);
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
                                    ReceiptDeliverList[index].F_Paper_No,
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
    List<ReceiptDeliver> filter = [];
    if (value == "" && value == " ") {
      ReceiptDeliverList = widget.receiptDeliverList;
      setState(() {});
    }
    for (var customer in widget.receiptDeliverList) {
      if (!isId) {
        if (value.length < customer.F_Paper_No.length) {
          if (customer.F_Paper_No.substring(0, value.length) == value) {
            filter.add(customer);
          }
        }
      } else {
        if (value.length <= customer.F_Paper_No.toString().length) {
          if (customer.F_Paper_No.toString().substring(0, value.length) == value) {
            filter.add(customer);
          }
        }
      }
    }

    ReceiptDeliverList = filter;
    setState(() {});
  }
}

