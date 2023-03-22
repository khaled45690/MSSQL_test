import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sql_test/DataTypes/CrewMember.dart';
import 'package:sql_test/DataTypes/Journey.dart';
import 'package:sql_test/StateManagement/JourneyData/JourneyData.dart';

import '../../../../DataTypes/Receipt.dart';
import '../../../../DataTypes/User.dart';
import '../../../../StateManagement/UserData/UserData.dart';
import '../TaskScreen.dart';

abstract class TaskScreenController extends State<TaskScreen> {
  String radioGroupValue = "Receive";
  Receipt receipt = Receipt.fromJson({});
  @override
  void initState() {
    super.initState();
  }

  bool isAddingNewReceipt = false;
  onRadioChangeCallback(String radioGroupValue) {
    this.radioGroupValue = radioGroupValue;
    setState(() {});
  }

  saveTempReceipt(Receipt receiptParameter) {
    receipt = receiptParameter;
  }

  saveReceiptInJouerny(Receipt receiptParameter) {
    widget.journey.receiptList.add(receiptParameter);
    List<Journey> journeyList = context.read<JourneyCubit>().state;
    journeyList[journeyList.length - 1] = widget.journey;
    context.read<JourneyCubit>().setjourneyDataWithSharedPrefrence(journeyList);
    isAddingNewReceipt = false;
    setState(() {});
    receipt = Receipt.fromJson({});
  }

  addNewReceipt() {
    User userData = context.read<UserCubit>().state!;
    CrewMember crewLeader =
        CrewMember(F_EmpID: userData.F_EmpID, F_EmpName: userData.F_EmpName);
    isAddingNewReceipt = true;
    receipt.F_Recipt_No = widget.journey.receiptList.length + 1;
    receipt.F_Id = widget.journey.F_Id;
    receipt.Userid_Save_ID = widget.journey.F_Emp_Id;
    receipt.F_Emp_Id_D = widget.journey.F_Emp_Id.toString();
    if (widget.journey.receiptList.isEmpty) {
      receipt.CrewIdList.add(crewLeader);
      saveTempReceipt(receipt);
    } else {
      receipt.CrewIdList = widget.journey
          .receiptList[widget.journey.receiptList.length - 1].CrewIdList;
    }

    setState(() {});
  }
}
