// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sql_conn/sql_conn.dart';
import 'package:sql_test/DataTypes/Receipt.dart';
import 'package:sql_test/StateManagement/InternetState/InternetStateHandler.dart';
import 'package:sql_test/StateManagement/JourneyData/JourneyData.dart';
import 'package:sql_test/Utilities/Extentions.dart';
import '../../../../DataTypes/Journey.dart';
import '../../../../DataTypes/User.dart';
import '../../../../StateManagement/UserData/UserData.dart';
import '../../../../Utilities/Prefs.dart';
import '../../../../Utilities/Strings.dart';
import '../JourneyScreen.dart';

abstract class JourneyScreenController extends State<JourneyScreen> {
  User? user;
  bool isfirstTime = false,
      isDataLoading = false,
      isStartEnabled = false,
      isEndEnabled = false;
  late StreamSubscription listener;
  late StreamSubscription<bool> internetConnectionListener;

  @override
  void initState() {
    super.initState();
    user = context.read<UserCubit>().getUserDataFromPref();
    Timer(const Duration(milliseconds: 1000), _getUserJournies);
    internetConnectionListener = InternetConnectionCubit
        .isConnectedToInternet.stream
        .listen(_connectionListenerFunction);

    // Timer(Duration(milliseconds: 2000), _updateDataBase);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    internetConnectionListener.cancel();
  }

  outDatedLoginCheacker() {
    bool isOutdatedLogin = DateTime.now()
            .difference(DateTime.parse(user!.dateOfLogin!))
            .inMinutes >
        60;

    if (isOutdatedLogin) {
      context.read<UserCubit>().setUserData(null);
      context.popupAllAndNavigateTo("/LoginScreen");
    }
  }

  startNewJourney() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(DateTime.now().year));
    if (pickedDate == null) return;

    isStartEnabled = false;
    setState(() {});
    if (context.read<JourneyCubit>().state.isEmpty) {
      Journey newJourney = Journey(
          F_Id: 1,
          F_Sdate: pickedDate.toString(),
          F_Stime: DateTime.now().toString(),
          F_Emp_Id: user!.F_EmpID,
          isFinished: false,
          receiptList: []);

      context
          .read<JourneyCubit>()
          .setjourneyDataWithSharedPrefrence([newJourney]);
    } else {
      List<Journey> currentJourneyList = context.read<JourneyCubit>().state;
      Journey latestJourney = currentJourneyList[currentJourneyList.length - 1];
      Journey newJourney = Journey(
          F_Id: latestJourney.F_Id + 1,
          F_Sdate: pickedDate.toString(),
          F_Stime: DateTime.now().toString(),
          F_Emp_Id: user!.F_EmpID,
          isFinished: false,
          receiptList: []);
      currentJourneyList.add(newJourney);
      context
          .read<JourneyCubit>()
          .setjourneyDataWithSharedPrefrence(currentJourneyList);
    }
    if (SqlConn.isConnected) await _updateDataBase();
    isEndEnabled = true;
    setState(() {});
  }

  endTheJourney() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime(DateTime.now().year + 100));
    if (pickedDate == null) return;

    isEndEnabled = false;
    setState(() {});
    List<Journey> currentJourneyList = context.read<JourneyCubit>().state;
    Journey latestJourney = currentJourneyList[currentJourneyList.length - 1];
    latestJourney.F_Edate = pickedDate.toString();
    latestJourney.F_Etime = DateTime.now().toString();
    latestJourney.isFinished = true;
    currentJourneyList[currentJourneyList.length - 1] = latestJourney;
    context
        .read<JourneyCubit>()
        .setjourneyDataWithSharedPrefrence(currentJourneyList);

    if (SqlConn.isConnected) await _updateDataBase();
    isStartEnabled = true;
    setState(() {});
  }

  reOpenLastJourney() {
    String? userJouerniesDataString = Prefs.getString(userJouernies);
    if (userJouerniesDataString == null) return;
    isStartEnabled = false;
    setState(() {});
    List<Journey> jouernies =
        Journey.fromJsonStringListToJourneyList(userJouerniesDataString);
    Journey latestJourney = jouernies[jouernies.length - 1];
    latestJourney.F_Edate = null;
    latestJourney.F_Etime = null;
    latestJourney.isFinished = false;
    jouernies[jouernies.length - 1] = latestJourney;
    context.read<JourneyCubit>().setjourneyDataWithSharedPrefrence(jouernies);
    if (SqlConn.isConnected) _updateDataBase();
    isEndEnabled = true;
    setState(() {});
  }

  _getUserJournies() async {
    isDataLoading = true;
    setState(() {});
    String? userJouerniesDataString = Prefs.getString(userJouernies);
    if (userJouerniesDataString == null) {
      if (!SqlConn.isConnected) return _waitForConnectionToGetData();

      await _getUserJourniesFromInternet();
      context.snackBar(dataHasBeenUpdated, color: Colors.green);
      isDataLoading = false;
      setState(() {});
    } else {
      List<Journey> jouernies =
          Journey.fromJsonStringListToJourneyList(userJouerniesDataString);
      if (jouernies.isEmpty) {
        _handelStartAndEndButton(null);
        context.read<JourneyCubit>().setjourneyData([]);
      } else {
        _handelStartAndEndButton(jouernies[jouernies.length - 1]);
        context.read<JourneyCubit>().setjourneyData(jouernies);
      }

      isDataLoading = false;
      setState(() {});
    }
  }

  _getUserJourniesFromInternet() async {
    String jouerniesDataString = await SqlConn.readData(
        "SELECT * from dbo.T_DAY WHERE F_Emp_Id = ${user!.F_EmpID} ORDER BY F_Id ASC");
    try {
      List<Journey> jouernies =
          Journey.fromJsonStringListToJourneyList(jouerniesDataString);
      if (jouernies.isEmpty) {
        _handelStartAndEndButton(null);
        return context
            .read<JourneyCubit>()
            .setjourneyDataWithSharedPrefrence([]);
      }
      context
          .read<JourneyCubit>()
          .setjourneyDataWithSharedPrefrence([jouernies[jouernies.length - 1]]);
      _handelStartAndEndButton(jouernies[jouernies.length - 1]);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _waitForConnectionToGetData() {
    context.snackBar(notSynchronizedData);
    isDataLoading = false;
    setState(() {});
    listener = InternetConnectionChecker().onStatusChange.listen(
      (InternetConnectionStatus status) {
        if (status == InternetConnectionStatus.connected) {
          isDataLoading = true;
          setState(() {});
          Timer(const Duration(milliseconds: 2000), () {
            _getUserJourniesFromInternet();
            context.snackBar(dataHasBeenUpdated, color: Colors.green);
            isDataLoading = false;
            setState(() {});
            listener.cancel();
          });
        }
      },
    );
  }

  _handelStartAndEndButton(Journey? lastJourney) {
    if (lastJourney == null) {
      isStartEnabled = true;
      setState(() {});
    } else {
      lastJourney.isFinished ? isStartEnabled = true : isEndEnabled = true;
    }
  }

  _connectionListenerFunction(bool isConnected) {
    if (isConnected) {
      Timer(const Duration(milliseconds: 2000), _updateDataBase);
    }
  }

  _updateDataBase() async {
    // so basicly what we do here is that we get all the data from the local and cload databases and see
    try {
      String? journiesString = Prefs.getString(userJouernies);
      if (journiesString == null) return;

      List<Journey> localJouernies =
          Journey.fromJsonStringListToJourneyList(journiesString);
      int localJouerniesLength = localJouernies.length;
      String jouerniesDataString = await SqlConn.readData(
          "SELECT * from dbo.T_DAY WHERE F_Emp_Id = ${user!.F_EmpID} AND F_Id >= ${localJouernies[0].F_Id} ORDER BY F_Id ASC");
      List<Journey> onlineJouernies =
          Journey.fromJsonStringListToJourneyList(jouerniesDataString);

      // if thee cloud doesn't have any data for the current user
      // then it will upload all the data to the cloud as insert query
      // if (onlineJouernies.isEmpty) {
      //   await _insertQuery(localJouernies);
      // } else {
      //   Journey journey = localJouernies[0];
      //   await _updateQuery(journey);
      //   if (localJouerniesLength > 1) {
      //     await _insertQuery(localJouernies.sublist(1));
      //   }
      // }

      context.snackBar(dataHasBeenUpdated, color: Colors.green.shade900);
    } catch (e) {
      context.snackBar(dataHasNotBeenUpdated, color: Colors.red.shade900);
      debugPrint(e.toString());
    }
  }

  _insertQuery(List<Journey> localJouernies) async {
    String query = "";
    for (Journey journey in localJouernies) {
      query +=
          " INSERT INTO dbo.T_DAY (F_Id, F_Sdate, F_Stime, F_Edate , F_Etime , F_Emp_Id) "
          "VALUES (${journey.F_Id} , CAST('${journey.F_Sdate}' AS DATETIME2) ,CAST('${journey.F_Stime}' AS DATETIME2) ,"
          "${journey.F_Edate == null ? null : "CAST('${journey.F_Edate}' AS DATETIME2)"} ,"
          "${journey.F_Etime == null ? null : "CAST('${journey.F_Etime}' AS DATETIME2)"} ,${journey.F_Emp_Id})";
    }
    await SqlConn.writeData(query);
    // after updating the data, Iam keeping the last Journey to know where we stopped
    // when we are offline and recoonected again
    // you will understand in the next condition handling
    Journey latestJourney = localJouernies[localJouernies.length - 1];

    context
        .read<JourneyCubit>()
        .setjourneyDataWithSharedPrefrence([latestJourney]);
  }

  _updateQuery(Journey journey) async {
    // String deliverRecieveM = await SqlConn.readData(
    //     "SELECT * from dbo.T_Deliver_Recieve_M WHERE F_Emp_Id_D = ${journey.F_Emp_Id} AND F_Id = ${journey.F_Id} ORDER BY F_Recipt_No ASC");
    // List<Receipt> onlineReceipt = [];
    // if (jsonDecode(deliverRecieveM)..isNotEmpty) {
    //   onlineReceipt = Receipt.fromJsonStringListToReceiptList(deliverRecieveM);
    // }
    String query = "UPDATE dbo.T_DAY"
        " SET F_Sdate = CAST('${journey.F_Sdate}' AS DATETIME2),"
        "F_Stime = CAST('${journey.F_Stime}' AS DATETIME2),"
        "F_Edate = ${journey.F_Edate == null ? null : "CAST('${journey.F_Edate}' AS DATETIME2)"},"
        "F_Etime = ${journey.F_Etime == null ? null : "CAST('${journey.F_Etime}' AS DATETIME2)"}"
        " WHERE F_Id = ${journey.F_Id} AND F_Emp_Id = ${journey.F_Emp_Id}";
    for (int i = 0; i < journey.receiptList.length; i++) {
      query += " INSERT INTO dbo.T_Deliver_Recieve_M"
      "(F_Recipt_No, F_Sdate, F_Stime, F_Edate , F_Etime , F_Emp_Id) VALUES "
          " SELECT MAX( F_Recipt_No ) + 1 FROM dbo.T_Deliver_Recieve_M,";
      for (int x = 0; x < journey.receiptList[i].CrewIdList.length; x++) {
        query +=
            "F_Team${x + 1} = ${journey.receiptList[i].CrewIdList[x].F_EmpID},";
      }
      query += "F_Cust_Id = ${journey.receiptList[i].F_Cust!.CustID},"
          "F_Note = ${journey.receiptList[i].F_Note},"
          "F_Note1 = ${journey.receiptList[i].F_Note1},"
          "F_Bank_Id_D = ${journey.receiptList[i].F_Cust!.CustID},"
          "F_Branch_Id_D = ${journey.receiptList[i].F_Branch_D!.F_Branch_Id},"
          "F_Branch_Internal_D = ${journey.receiptList[i].F_Branch_D!.F_Branch_Internal},"
          "F_Arrival_Time_D = ${journey.receiptList[i].F_Arrival_Time_D},"
          "F_Leaving_Time_D = ${journey.receiptList[i].F_Leaving_Time_D},"
          "F_Bank_Id_R = ${journey.receiptList[i].F_Cust_R!.CustID},"
          "F_Branch_Id_R = ${journey.receiptList[i].F_Branch_R!.F_Branch_Id},"
          "F_Branch_Internal_R = ${journey.receiptList[i].F_Branch_R!.F_Branch_Internal},"
          "Date_Save = CAST('${journey.receiptList[i].Date_Save ?? DateTime.now().toString()}' AS DATETIME2),"
          "Time_Save = CAST('${journey.receiptList[i].Time_Save ?? DateTime.now().toString()}' AS DATETIME2),"
          // "F_Attachment = ${journey.receiptList[i].imagesAsPDF},"
          "F_Date = CAST('${journey.receiptList[i].F_Date}' AS DATETIME2),"
          "F_count = ${journey.receiptList[i].F_count},"
          "F_Sell_Inv_No = ${journey.receiptList[i].F_Sell_Inv_No},"
          "F_SaleD = ${journey.receiptList[i].F_SaleD},"
          "F_Local_Tot = ${journey.receiptList[i].F_Local_Tot},"
          "F_Global_Tot = ${journey.receiptList[i].F_Global_Tot},"
          "F_Coin_Tot = ${journey.receiptList[i].F_Coin_Tot},"
          "F_Local_Fees = 0,"
          "F_Global_Fees = 0,"
          "F_Coin_Fees = 0,"
          "F_Reviewd = ${journey.receiptList[i].F_Reviewd},"
          "F_totalAmount_EGP = ${journey.receiptList[i].F_totalAmount_EGP},"
          "F_totalFees_Amount = ${journey.receiptList[i].F_totalFees_Amount},"
          "F_Recipt_Type = ${journey.receiptList[i].F_Recipt_Type.receiptTypeNumber},"
          "F_Id = ${journey.receiptList[i].F_Id}";
    }
    debugPrint(query, wrapWidth: 150);
    await SqlConn.writeData(query);
  }
}
