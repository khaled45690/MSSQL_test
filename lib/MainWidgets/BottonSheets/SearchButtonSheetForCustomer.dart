import 'package:flutter/material.dart';
import 'package:sql_test/DataTypes/Customer.dart';
import 'package:sql_test/Utilities/Extentions.dart';
import 'package:sql_test/Utilities/colors.dart';

import '../../Utilities/Style.dart';
import '../SearchTextField.dart';



Map<int, Color> color = {
  50: Colors.white,
  100: Colors.white,
  200: Colors.white,
};

searchButtonSheetForCustomer(BuildContext context, List<Customer> customerList,
    Function(Customer customer , bool isDeliveredTo) onSelectCustomerFunc , bool isDeliveredTo) {
  Scaffold.of(context).showBottomSheet<void>(
    clipBehavior: Clip.antiAlias,
    elevation: 3,
    enableDrag: false,
    (BuildContext context) {
      return CustomSearchWithFilterWidget(customerList, onSelectCustomerFunc , isDeliveredTo);
    },
  );
}

class CustomSearchWithFilterWidget extends StatefulWidget {
  final List<Customer> customerList;
  final Function(Customer customer , bool isDeliveredTo) onSelectCustomerFunc;
  final bool isDeliveredTo;
  const CustomSearchWithFilterWidget(
      this.customerList, this.onSelectCustomerFunc,this.isDeliveredTo,
      {super.key});

  @override
  State<CustomSearchWithFilterWidget> createState() =>
      _CustomSearchWithFilterWidgetState();
}

class _CustomSearchWithFilterWidgetState
    extends State<CustomSearchWithFilterWidget> {
  late List<Customer> customerList;
  bool isId = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    customerList = widget.customerList;
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
                    itemCount: customerList.length,
                    itemBuilder: (listContext, index) {
                      return MaterialButton(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        splashColor: Colors.lightBlue.withOpacity(.7),
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onSelectCustomerFunc(customerList[index] , widget.isDeliveredTo);
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
                                        ? customerList[index].CustID.toString()
                                        : customerList[index].CustName,
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
    List<Customer> filter = [];
    if (value == "" && value == " ") {
      customerList = widget.customerList;
      setState(() {});
    }
    for (var customer in widget.customerList) {
      if (!isId) {
        if (value.length < customer.CustName.length) {
          if (customer.CustName.substring(0, value.length) == value) {
            filter.add(customer);
          }
        }
      } else {
        if (value.length <= customer.CustID.toString().length) {
          if (customer.CustID.toString().substring(0, value.length) == value) {
            filter.add(customer);
          }
        }
      }
    }

    customerList = filter;
    setState(() {});
  }
}
