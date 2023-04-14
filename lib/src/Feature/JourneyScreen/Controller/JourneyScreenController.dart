// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sql_conn/sql_conn.dart';
import 'package:sql_test/src/DataTypes/Receipt.dart';
import 'package:sql_test/src/StateManagement/InternetState/InternetStateHandler.dart';
import 'package:http/http.dart' as http;
import 'package:sql_test/src/StateManagement/JourneyData/JourneyData.dart';
import 'package:sql_test/src/Utilities/Extentions.dart';
import '../../../DataTypes/CrewMember.dart';
import '../../../DataTypes/Journey.dart';
import '../../../DataTypes/ReceiptDetails.dart';
import '../../../DataTypes/User.dart';
import '../../../StateManagement/UserData/UserData.dart';
import '../../../Utilities/Prefs.dart';
import '../../../Utilities/Strings.dart';
import '../JourneyScreen.dart';
import 'package:convert/convert.dart';

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
    Timer(const Duration(milliseconds: 1000), initialFunction);
    // tagraba();
    // Timer(Duration(milliseconds: 2000), _updateDataBase);
  }

  tagraba() async {
    String customerData = await SqlConn.readData(
        "SELECT F_Cust_Id , F_Attachment from dbo.T_Deliver_Recieve_M WHere F_Recipt_No = 3");
    List customersData = jsonDecode(customerData);

    // List da = customersData[0]["F_Attachment"];R
    // final List<int> codeUnits = customersData[0]["F_Attachment"].codeUnits;
    // final Uint8List unit8List = Uint8List.fromList(codeUnits);
    debugPrint(customersData[0]["F_Attachment"].toString());

    var url = Uri.parse('http://192.168.1.7:3000/savePDF');
    var response = await http.post(url,
        body: jsonEncode({'pdfData': customersData[0]["F_Attachment"]}),
        headers: {"Content-Type": "application/json"});
  }

  initialFunction() async {
    _getUserJournies();
    internetConnectionListener = InternetConnectionCubit
        .isConnectedToInternet.stream
        .listen(_connectionListenerFunction);
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
        lastDate: DateTime(DateTime.now().year + 1));
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
    if (SqlConn.isConnected) await updateDataBase();
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

    if (SqlConn.isConnected) await updateDataBase();
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
    if (SqlConn.isConnected) updateDataBase();
    isEndEnabled = true;
    setState(() {});
  }

  updateDataBase() async {
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
      if (onlineJouernies.isEmpty) {
        await _insertQuery(localJouernies);
      } else {
        Journey journey = localJouernies[0];
        await _updateQuery(journey, localJouerniesLength > 1);
        if (localJouerniesLength > 1) {
          await _insertQuery(localJouernies.sublist(1));
        }
      }

      context.snackBar(dataHasBeenUpdated, color: Colors.green.shade900);
    } catch (e) {
      context.snackBar(dataHasNotBeenUpdated, color: Colors.red.shade900);
    }
  }

  ///////////////////////////////////////////////////////////////////////////
  //                                                                       //
  //                                                                       //
  //                                                                       //
  //  the seperator between the Main function and their helpers functions  //
  //                                                                       //
  //                                                                       //
  //                                                                       //
  ///////////////////////////////////////////////////////////////////////////

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
        Journey latestJourney = jouernies[jouernies.length - 1];
        if (latestJourney.F_Emp_Id != user!.F_EmpID) {
          await _getUserJourniesFromInternet();
          context.snackBar(dataHasBeenUpdated, color: Colors.green);
        } else {
          if (SqlConn.isConnected) {
            String jouerniesDataString = await SqlConn.readData(
                "SELECT * from dbo.T_DAY WHERE F_Emp_Id = ${user!.F_EmpID} ORDER BY F_Id ASC");
            List<Journey> jouerniesFromDatabase =
                Journey.fromJsonStringListToJourneyList(jouerniesDataString);

            if (jouerniesFromDatabase.isEmpty) {
              _handelStartAndEndButton(null);
              context.read<JourneyCubit>().setjourneyData([]);
            } else {
              _handelStartAndEndButton(jouernies[jouernies.length - 1]);
              context.read<JourneyCubit>().setjourneyData(jouernies);
            }
          } else {
            _handelStartAndEndButton(jouernies[jouernies.length - 1]);
            context.read<JourneyCubit>().setjourneyData(jouernies);
          }
        }
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

      String jouerniesRecieptsDataString = await SqlConn.readData(
          "SELECT * from dbo.T_Deliver_Recieve_M WHERE F_Emp_Id_D = ${user!.F_EmpID} AND F_Id = ${jouernies[jouernies.length - 1].F_Id} ORDER BY F_Recipt_No ASC");
      List<Receipt> receipts = Receipt.fromJsonStringListToReceiptList(
          jouerniesRecieptsDataString,
          isUpdatingFromDatabase: true);
      for (var i = 0; i < receipts.length; i++) {
        String RecieptsDetailsDataString = await SqlConn.readData(
            "SELECT * from dbo.T_Deliver_Recieve_D WHERE F_Recipt_No = ${receipts[i].F_Recipt_No}");
        receipts[i].ReceiptDetailsList =
            ReceiptDetails.fromJsonStringListToReceiptDetailsList(
                RecieptsDetailsDataString);
        receipts[i].isSavedInDatabase = true;
      }
      Journey dumyJoureny = jouernies[jouernies.length - 1];
      dumyJoureny.receiptList = receipts;
      context
          .read<JourneyCubit>()
          .setjourneyDataWithSharedPrefrence([dumyJoureny]);
      _handelStartAndEndButton(dumyJoureny);
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
      Timer(const Duration(milliseconds: 2000), updateDataBase);
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

      query += "BEGIN TRANSACTION; DECLARE @recipt_no INT;";
      query += _receiptQuery(journey.receiptList);
      query += "COMMIT TRANSACTION";
    }
    await SqlConn.writeData(query);
    // after updating the data, Iam keeping the last Journey to know where we stopped
    // when we are offline and recoonected again
    // you will understand in the next condition handling
    Journey latestJourney = localJouernies[localJouernies.length - 1];
    _receiptNoUpdate(latestJourney);
  }

  _updateQuery(Journey journey, bool isThereInsert) async {
    String query = "UPDATE dbo.T_DAY"
        " SET F_Sdate = CAST('${journey.F_Sdate}' AS DATETIME2),"
        "F_Stime = CAST('${journey.F_Stime}' AS DATETIME2),"
        "F_Edate = ${journey.F_Edate == null ? null : "CAST('${journey.F_Edate}' AS DATETIME2)"},"
        "F_Etime = ${journey.F_Etime == null ? null : "CAST('${journey.F_Etime}' AS DATETIME2)"}"
        " WHERE F_Id = ${journey.F_Id} AND F_Emp_Id = ${journey.F_Emp_Id}";

    query += "BEGIN TRANSACTION; DECLARE @recipt_no INT;";
    query += _receiptQuery(journey.receiptList);
    query += "COMMIT TRANSACTION";
    await SqlConn.writeData(query);

    if (!isThereInsert) {
      _receiptNoUpdate(journey);
    }
  }

  _receiptNoUpdate(Journey journey) async {
    String updateQuery = "BEGIN TRANSACTION; DECLARE @recipt_no INT;";

    for (int i = 0; i < journey.receiptList.length; i++) {
      debugPrint("journey.receiptList[i].isSavedInDatabase.toString()");
      debugPrint(journey.receiptList[i].isSavedInDatabase.toString());
      if (journey.receiptList[i].isSavedInDatabase) {
        updateQuery += "SET @recipt_no=${journey.receiptList[i].F_Recipt_No};";

        updateQuery += _updateReceiptQuery(journey.receiptList[i]);

        updateQuery +=
            "DELETE FROM dbo.T_Deliver_Recieve_D WHERE F_Recipt_No = @recipt_no;";
        updateQuery +=
            _receiptDetailsData(journey.receiptList[i].ReceiptDetailsList);
      } else {
        String query =
            "SELECT F_Recipt_No , F_Cust_Id , F_Paper_No FROM dbo.T_Deliver_Recieve_M "
            "WHERE F_Bank_Id_D = ${journey.receiptList[i].F_Cust!.CustID} AND F_Paper_No = ${journey.receiptList[i].F_Paper_No} AND F_Emp_Id_D = ${journey.receiptList[i].F_Emp_Id_D} AND "
            "F_Branch_Id_D = ${journey.receiptList[i].F_Branch_D!.F_Branch_Id} AND F_Id = ${journey.receiptList[i].F_Id}";

        String receiptDataString = await SqlConn.readData(query);
        List receiptDataList = jsonDecode(receiptDataString);
        debugPrint(receiptDataList.length.toString());
        journey.receiptList[i].F_Recipt_No =
            receiptDataList[receiptDataList.length - 1]["F_Recipt_No"];
        journey.receiptList[i].isSavedInDatabase = true;
      }
    }
    updateQuery += " COMMIT TRANSACTION;";
    await SqlConn.writeData(updateQuery);
    context.read<JourneyCubit>().setjourneyDataWithSharedPrefrence([journey]);
  }

  String _receiptQuery(List<Receipt> receiptList) {
    String query = "";

    for (int i = 0; i < receiptList.length; i++) {
      Map<String, String> crewList = {};
      crewList = _insertCrewMemberQuery(receiptList[i].CrewIdList);
      if (!receiptList[i].isSavedInDatabase) {
        receiptList[i].Date_Save = DateTime.now().toString();
        receiptList[i].Time_Save = DateTime.now().toString();

        var pdfInHexFormate = hex.encode(receiptList[i].imagesAsPDF!.toList());
        query +=
            "SELECT @recipt_no = ISNULL(MAX(F_Recipt_No), 0) + 1 FROM dbo.T_Deliver_Recieve_M;"
            "INSERT INTO dbo.T_Deliver_Recieve_M (F_Recipt_No , F_Cust_Id , F_Emp_Id_D, F_Note, F_Note1, F_Bank_Id_D, F_Branch_Id_D ,"
            "F_Branch_Internal_D, F_Arrival_Time_D, F_Leaving_Time_D, F_Bank_Id_R,"
            " F_Branch_Id_R, F_Branch_Internal_R, Date_Save, Time_Save,F_Date,F_count,F_Sell_Inv_No,"
            "F_SaleD,F_Local_Tot,F_Global_Tot,F_Coin_Tot,F_Local_Fees,F_Global_Fees,F_Coin_Fees,F_Reviewd,F_totalAmount_EGP,"
            "F_totalFees_Amount,F_Recipt_Type ,F_Id , Userid_Save_ID, F_Paper_No, ${crewList["crewListQuery"]} , F_Attachment)"
            " VALUES (@recipt_no, ${receiptList[i].F_Cust!.CustID}, ${receiptList[i].F_Emp_Id_D},"
            "'${receiptList[i].F_Note} ' ,'${receiptList[i].F_Note1}' , ${receiptList[i].F_Cust!.CustID} , ${receiptList[i].F_Branch_D!.F_Branch_Id},"
            "${receiptList[i].F_Branch_D!.F_Branch_Internal} , '${receiptList[i].F_Arrival_Time_D}','${receiptList[i].F_Leaving_Time_D}', ${receiptList[i].F_Cust_R!.CustID},"
            " ${receiptList[i].F_Branch_R!.F_Branch_Id}, ${receiptList[i].F_Branch_R!.F_Branch_Internal},"
            "CAST('${receiptList[i].Date_Save}' AS DATETIME2),CAST('${receiptList[i].Time_Save}' AS DATETIME2),CAST('${receiptList[i].F_Date}' AS DATETIME2), ${receiptList[i].F_count}, ${receiptList[i].F_Sell_Inv_No},"
            " ${receiptList[i].F_SaleD},${receiptList[i].F_Local_Tot},"
            "${receiptList[i].F_Global_Tot}, ${receiptList[i].F_Coin_Tot},0,0,0,${receiptList[i].F_Reviewd} , ${receiptList[i].F_totalAmount_EGP},"
            "${receiptList[i].F_totalFees_Amount},${receiptList[i].F_Recipt_Type.receiptTypeNumber},${receiptList[i].F_Id} , ${receiptList[i].Userid_Save_ID} , ${receiptList[i].F_Paper_No},${crewList["crewListValues"]} ,CONVERT(VARBINARY(MAX), '$pdfInHexFormate' , 2));";
        query += _receiptDetailsData(receiptList[i].ReceiptDetailsList);
      }
    }

    return query;
  }

  String _receiptDetailsData(List<ReceiptDetails> receiptDetailsList) {
    String query = "";
    for (var i = 0; i < receiptDetailsList.length; i++) {
      query += _insertReceiptDetailsDataQuery(receiptDetailsList[i]);
    }

    return query;
  }

  _insertReceiptDetailsDataQuery(ReceiptDetails receiptDetails) {
    return "INSERT INTO dbo.T_Deliver_Recieve_D "
        "(F_Recipt_No , F_Seal_No_From , F_Currency_Id , F_Packs_No,"
        "F_Pack_Class , F_Banknote_No , F_Banknote_Class, F_Package_No , F_Package_Value,"
        "F_Total_val , F_RowNo , F_Currency_Type,F_Unite_ID , "
        "F_Convert_Factor,F_EGP_Amount ,F_Seal_No_To, F_Bags_No) "
        "VALUES "
        "(@recipt_no , ${receiptDetails.F_Seal_No_From} , ${receiptDetails.F_Currency_Id.F_CURRANCY_ID} , ${receiptDetails.F_Pack_No},"
        "${receiptDetails.F_Pack_Class},${receiptDetails.F_BankNote_No},${receiptDetails.F_BankNote_Class},0 , 0,"
        "${receiptDetails.F_Total_val} , ${receiptDetails.F_RowNo},${receiptDetails.F_Currency_Type},${receiptDetails.F_Uinte_Id} , "
        "${receiptDetails.F_Convert_Factor},${receiptDetails.F_EGP_Amount},${receiptDetails.F_Seal_No_To},${receiptDetails.F_Bags_No});";
  }

  _insertCrewMemberQuery(List<CrewMember> crewList) {
    String crewListQuery = "";
    String crewListValues = "";

    for (int x = 0; x < crewList.length; x++) {
      crewListQuery += "F_Team${x + 1}";
      crewListValues += "${crewList[x].F_EmpID}";
      if (x < crewList.length - 1) {
        crewListQuery += ",";
        crewListValues += ",";
      }
    }

    return {"crewListQuery": crewListQuery, "crewListValues": crewListValues};
  }

  _updateCrewMemberQuery(List<CrewMember> crewList) {
    String crewListQuery = "";

    for (int x = 0; x < crewList.length; x++) {
      crewListQuery += "F_Team${x + 1} = ${crewList[x].F_EmpID}";
      if (x < crewList.length - 1) {
        crewListQuery += ",";
      }
    }

    return crewListQuery;
  }

  _updateReceiptQuery(Receipt receipt) {
    String crewList = _updateCrewMemberQuery(receipt.CrewIdList);
    var pdfInHexFormate = hex.encode(receipt.imagesAsPDF!.toList());

    return " UPDATE dbo.T_Deliver_Recieve_M"
        " SET F_Cust_Id = ${receipt.F_Cust!.CustID}, F_Emp_Id_D = ${receipt.F_Emp_Id_D}, F_Note = '${receipt.F_Note}' , F_Note1 = '${receipt.F_Note1}',"
        " F_Bank_Id_D = ${receipt.F_Cust!.CustID}, F_Branch_Id_D = ${receipt.F_Branch_D!.F_Branch_Id}, "
        "F_Branch_Internal_D = ${receipt.F_Branch_D!.F_Branch_Internal}, F_Arrival_Time_D = '${receipt.F_Arrival_Time_D}',"
        " F_Leaving_Time_D = '${receipt.F_Leaving_Time_D}', F_Bank_Id_R = ${receipt.F_Cust_R!.CustID},"
        " F_Branch_Id_R = ${receipt.F_Branch_R!.F_Branch_Id}, F_Branch_Internal_R = ${receipt.F_Branch_R!.F_Branch_Internal},"
        " Date_Save = CAST('${receipt.Date_Save}' AS DATETIME2), Time_Save = CAST('${receipt.Time_Save}' AS DATETIME2),"
        "F_Date = CAST('${receipt.F_Date}' AS DATETIME2),"
        "F_Local_Tot = ${receipt.F_Local_Tot},F_Global_Tot = ${receipt.F_Global_Tot},"
        "F_Coin_Tot = ${receipt.F_Coin_Tot},F_totalAmount_EGP = ${receipt.F_totalAmount_EGP},"
        "F_Recipt_Type = ${receipt.F_Recipt_Type.receiptTypeNumber},"
        "F_Paper_No = ${receipt.F_Paper_No}, $crewList , F_Attachment = CONVERT(VARBINARY(MAX), '$pdfInHexFormate' , 2)"
        " WHERE F_Recipt_No = @recipt_no;";
  }
}
