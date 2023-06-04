// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sql_test/src/DataTypes/CrewMember.dart';
import 'package:sql_test/src/Utilities/Extentions.dart';

import '../../../../../../StateManagement/UserData/UserData.dart';
import '../../../../../../Utilities/Style.dart';




class CustomListView extends StatelessWidget {
  final List<CrewMember> employees;
  final Function(int empId) removeEMp;
  const CustomListView(this.employees, this.removeEMp,{super.key});

  @override
  Widget build(BuildContext context) {
        int userId = context.watch<UserCubit>().state!.F_EmpID;
    return employees.isEmpty
        ? const SizedBox()
        : Container(
            width: context.width() - 60,
            padding: const EdgeInsets.only(right: 10, bottom: 30),
            decoration: lightBlueAccent20percentageWithRadius10Decoration,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: employees.length,
              itemBuilder: (context, index) {
                String textString =
                    "${index + 1}) ${employees[index].F_EmpName}";
                return Container(
                  margin: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Text(
                      textString,
                      style: size19BlackTextStyle,
                    ),
                    userId == employees[index].F_EmpID ? const SizedBox():IconButton(onPressed: ()=>removeEMp(employees[index].F_EmpID), icon: const Icon(Icons.delete , color: Colors.red , size: 25,))
                  ]),
                );
              },
            ),
          );
  }
}
