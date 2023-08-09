// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:sql_test/src/DataTypes/CompanyBranch.dart';
import 'package:sql_test/src/Utilities/Extentions.dart';
import 'package:sql_test/src/Utilities/colors.dart';

import '../../Utilities/Style.dart';
import '../SearchTextField.dart';

Map<int, Color> color = {
  50: Colors.white,
  100: Colors.white,
  200: Colors.white,
};

searchButtonSheetForInternalBranch(BuildContext context, List<CompanyBranch> companyBranchList, Function(CompanyBranch companyBranchList) onSelectCustomerFunc) {
  Scaffold.of(context).showBottomSheet<void>(
    clipBehavior: Clip.antiAlias,
    elevation: 3,
    enableDrag: false,
    (BuildContext context) {
      return CustomSearchWithFilterWidget(companyBranchList, onSelectCustomerFunc);
    },
  );
}

class CustomSearchWithFilterWidget extends StatefulWidget {
  final List<CompanyBranch> companyBranchList;
  final Function(CompanyBranch companyBranchList) onSelectCustomerFunc;
  const CustomSearchWithFilterWidget(this.companyBranchList, this.onSelectCustomerFunc, {super.key});

  @override
  State<CustomSearchWithFilterWidget> createState() => _CustomSearchWithFilterWidgetState();
}

class _CustomSearchWithFilterWidgetState extends State<CustomSearchWithFilterWidget> {
  late List<CompanyBranch> companyBranchList;
  bool isId = false;
  @override
  void initState() {
    super.initState();
    companyBranchList = widget.companyBranchList;
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
                  margin: const EdgeInsets.only(right: 0, top: 140),
                  width: context.width() - 50,
                  height: context.width() - 90,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: companyBranchList.length,
                    itemBuilder: (listContext, index) {
                      return MaterialButton(
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                        splashColor: Colors.lightBlue.withOpacity(.7),
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onSelectCustomerFunc(companyBranchList[index]);
                        },
                        child: Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            width: double.infinity,
                            padding: const EdgeInsets.all(0),
                            child: Row(
                              textDirection: TextDirection.rtl,
                              children: [
                                Checkbox(checkColor: Colors.white, activeColor: mainBlue, side: const BorderSide(color: Colors.white), value: false, onChanged: (isChecked) {}),
                                SizedBox(
                                  width: 170,
                                  child: Text(
                                    companyBranchList[index].F_Sort_Loc_Name,
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
    List<CompanyBranch> filter = [];
    if (value == "" && value == " ") {
      companyBranchList = widget.companyBranchList;
      setState(() {});
    }
    for (var customer in widget.companyBranchList) {
      if (!isId) {
        if (value.length < customer.F_Sort_Loc_Name.length) {
          if (customer.F_Sort_Loc_Name.substring(0, value.length) == value) {
            filter.add(customer);
          }
        }
      } else {
        if (value.length <= customer.F_Sort_Loc_Id.toString().length) {
          if (customer.F_Sort_Loc_Id.toString().substring(0, value.length) == value) {
            filter.add(customer);
          }
        }
      }
    }

    companyBranchList = filter;
    setState(() {});
  }
}
