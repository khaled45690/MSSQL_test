import 'package:flutter/material.dart';
import 'package:sql_test/DataTypes/Customer.dart';
import 'package:sql_test/DataTypes/CustomerBranch.dart';
import 'package:sql_test/Utilities/Extentions.dart';
import 'package:sql_test/Utilities/colors.dart';

import '../../Utilities/Style.dart';
import '../SearchTextField.dart';


Map<int, Color> color = {
  50: Colors.white,
  100: Colors.white,
  200: Colors.white,
};

searchButtonSheetForBranch(BuildContext context, List<CustomerBranch> customerBranchList,
    Function(CustomerBranch customerBranch , bool isDeliveredTo) onSelectCustomerFunc , bool isDeliveredTo) {
  Scaffold.of(context).showBottomSheet<void>(
    clipBehavior: Clip.antiAlias,
    elevation: 3,
    enableDrag: false,
    (BuildContext context) {
      return CustomSearchWithFilterWidget(customerBranchList, onSelectCustomerFunc , isDeliveredTo);
    },
  );
}

class CustomSearchWithFilterWidget extends StatefulWidget {
  final List<CustomerBranch> customerBranchList;
  final Function(CustomerBranch customerBranch, bool isDeliveredTo) onSelectCustomerFunc;
  final bool isDeliveredTo;
  const CustomSearchWithFilterWidget(
      this.customerBranchList, this.onSelectCustomerFunc,this.isDeliveredTo,
      {super.key});

  @override
  State<CustomSearchWithFilterWidget> createState() =>
      _CustomSearchWithFilterWidgetState();
}

class _CustomSearchWithFilterWidgetState
    extends State<CustomSearchWithFilterWidget> {
  late List<CustomerBranch> customerList;
  bool isId = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    customerList = widget.customerBranchList;
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
                                        ? customerList[index].F_Branch_Id.toString()
                                        : customerList[index].F_Branch_Name,
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
    List<CustomerBranch> filter = [];
    if (value == "" && value == " ") {
      customerList = widget.customerBranchList;
      setState(() {});
    }
    for (var customer in widget.customerBranchList) {
      if (!isId) {
        if (value.length < customer.F_Branch_Name.length) {
          if (customer.F_Branch_Name.substring(0, value.length) == value) {
            filter.add(customer);
          }
        }
      } else {
        if (value.length <= customer.F_Branch_Id.toString().length) {
          if (customer.F_Branch_Id.toString().substring(0, value.length) == value) {
            filter.add(customer);
          }
        }
      }
    }

    customerList = filter;
    setState(() {});
  }
}
