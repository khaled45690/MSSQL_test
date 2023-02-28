import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as format;
import 'package:sql_test/Utilities/colors.dart';

import '../../../Utilities/Style.dart';
import 'Widget/AddButton.dart';
import 'Widget/BagsContent.dart';
import 'Widget/CustomTextField.dart';
import 'Widget/DropDownWithSearch.dart';
import 'Widget/EmployeeWithCar.dart';
import 'Widget/ReceiverData.dart';
import 'Widget/SenderData.dart';

class DeliveryDataScreen extends StatefulWidget {
  final bool isReciever;
  const DeliveryDataScreen(this.isReciever, {super.key});

  @override
  State<DeliveryDataScreen> createState() => _DeliveryDataScreenState();
}

class _DeliveryDataScreenState extends State<DeliveryDataScreen> {
  List<String> list = <String>[
    'one',
    'two',
    'three',
    'four',
    'five',
    'six',
    'seven',
    'eight',
  ];
  List<String> listFilter = [];
  String? searchText;
  String? text;
  int numberOfBags = 1;
  int numberOfRiders = 2;
  late String arriveTime, leaveTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listFilter = list;
    arriveTime = format.DateFormat('h:mm:ssa').format(DateTime.now());
    leaveTime = format.DateFormat('h:mm:ssa').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isReciever ? "استلام" : "تسليم"),
        centerTitle: true,
        backgroundColor: mainBlue,
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    const Text(
                      "كود الايصال",
                      style: size19BlackTextStyle,
                    ),
                    DropDownWithSearch(list, onSearchChange, onItemChange, text)
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    const Text(
                      "كود العميل",
                      style: size19BlackTextStyle,
                    ),
                    DropDownWithSearch(list, onSearchChange, onItemChange, text)
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    const Text(
                      " كود الايصال الدفترى",
                      style: size19BlackTextStyle,
                    ),
                    DropDownWithSearch(list, onSearchChange, onItemChange, text)
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    const Text(
                      "بيـان",
                      style: size19BlackTextStyle,
                    ),
                    CustomTextField((da, value) {}),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    const Text(
                      "ملاحظات",
                      style: size19BlackTextStyle,
                    ),
                    CustomTextField((da, value) {}),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),

                EmployeeWithCar(
                    list, onSearchChange, onItemChange, text, numberOfRiders),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  textDirection: TextDirection.rtl,
                  children: [
                    AddButton("اضافة مرافق", () => addAndRemoveRider(true)),
                    AddButton("حذف مرافق", () => addAndRemoveRider(false))
                  ],
                ),

                for (int i = 0; i < numberOfBags; i++)
                  BagsContent(list, onSearchChange, onItemChange, text),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  textDirection: TextDirection.rtl,
                  children: [
                    AddButton("اضافة شنطة", () => addAndRemoveFunction(true)),
                    AddButton("حذف شنطة", () => addAndRemoveFunction(false))
                  ],
                ),
                widget.isReciever
                    ? ReceiverData(list, onSearchChange, onItemChange, text)
                    : SenderData(list, onSearchChange, onItemChange, text),
                // ---------------------------------------------------------------->>>>>
                Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const Text(
                          "معاد الوصول",
                          style: size19BlackTextStyle,
                        ),
                        RawMaterialButton(
                          onPressed: () {},
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: dropDownDecoration,
                            child: Text(
                              arriveTime,
                              style: size19BlackTextStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          "معاد المغادرة",
                          style: size19BlackTextStyle,
                        ),
                        RawMaterialButton(
                          onPressed: () {},
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: dropDownDecoration,
                            child: Text(
                              arriveTime,
                              style: size19BlackTextStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
                // ---------------------------------------------------------------->>>>>
              ],
            )),
      ),
    );
  }

  onItemChange(String item) {
    text = item;
    setState(() {});
  }

  List<String> onSearchChange(List<String> list, String? search) {
    if (search == null) return list;
    List<String> filter = [];
    if (search == null) return list;
    for (var element in list) {
      if (element.length >= search.length) {
        if (element.substring(0, search.length).toLowerCase() ==
            search.toLowerCase()) filter.add(element);
      }
    }
    return filter;
  }

  addAndRemoveFunction(bool isAdding) {
    if (isAdding) {
      numberOfBags++;
      setState(() {});
    } else {
      if (numberOfBags > 1) numberOfBags--;

      setState(() {});
    }
  }

  addAndRemoveRider(bool isAdding) {
    if (isAdding) {
      if (numberOfRiders < 6) numberOfRiders++;
      setState(() {});
    } else {
      if (numberOfRiders > 1) numberOfRiders--;

      setState(() {});
    }
  }
}
