import 'package:flutter/material.dart';
import 'package:sql_test/Utilities/Extentions.dart';

import '../../../../Utilities/Style.dart';
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
                decoration: cartWidgetDecoration,
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
                            margin: EdgeInsets.all(60),
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


// Scaffold.of(context).showBottomSheet<void>(
//             (BuildContext context) {
//               return Container(
//                 height: 200,
//                 color: Colors.amber,
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       const Text('BottomSheet'),
//                       ElevatedButton(
//                         child: const Text('Close BottomSheet'),
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );

// DropdownButton<String>(
//       value: list[0],
//       icon: const Icon(Icons.arrow_downward),
//       elevation: 16,
//       style: const TextStyle(color: Colors.deepPurple),
//       underline: Container(
//         height: 2,
//         color: Colors.deepPurpleAccent,
//       ),
//       onChanged: (String? value) {
//         // This is called when the user selects an item.
//       },
    
//       items: list.map<DropdownMenuItem<String>>((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//     )