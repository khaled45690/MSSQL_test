// ignore_for_file: file_names, invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sql_conn/sql_conn.dart';
import 'package:sql_test/DataTypes/Currency.dart';
import 'package:sql_test/DataTypes/Customer.dart';
import 'package:sql_test/DataTypes/CustomerBranch.dart';

import '../../Utilities/Prefs.dart';
import '../../Utilities/Strings.dart';
import '../../DataTypes/User.dart';

bool? isssssssConnected;
setConnectionssss(bool internetConnectionState) {
  isssssssConnected = internetConnectionState;
}

//BlocStateListener  BlocStateType
class InternetConnectionCubit extends Cubit<bool> {
  // pass the initial value with super
  InternetConnectionCubit() : super(true);
  static StreamController<bool> isConnectedToInternet =
      StreamController<bool>.broadcast();
  // initialize UserData
  static bool isConnected = true;
  late StreamSubscription<InternetConnectionStatus> listener;

  setConnection(bool internetConnectionState) {
    isConnected = internetConnectionState;
    isConnectedToInternet.sink.add(internetConnectionState);
    emit(isConnected);
  }

  connectionCheckerInitializer() {
    listener = InternetConnectionChecker().onStatusChange.listen(
      (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            if (!SqlConn.isConnected) {
              SqlConn.connect(
                      ip: "196.218.142.75",
                      port: "1455",
                      databaseName: "SWAT_${DateTime.now().year}",
                      username: "sa",
                      password: "bbs66666")
                  .then((value) => _connected());
            } else {
              _connected();
            }
            break;
          case InternetConnectionStatus.disconnected:
            if (SqlConn.isConnected) {
              SqlConn.disconnect().then((value) => _disconnected());
            } else {
              _disconnected();
            }

            break;
        }
      },
    );
  }

  _connected() {
    debugPrint("Connected");
    setConnection(true);
    _updateUsers();
    _updateCustomers();
    _updateCurrency();
  }

  _disconnected() {
    debugPrint("Disconnected");
    setConnection(false);
  }

  _updateUsers() {
    SqlConn.readData("SELECT * from dbo.T_Employee").then(
        (employersDataString) => _saveDataInLocalStorage(
            employersDataString, allUsersFromLocaleDataBase));
    SqlConn.readData("SELECT * from dbo.T_Employee WHERE F_Prevlage = 3").then(
        (employersDataString) => _saveDataInLocalStorage(
            employersDataString, driversFromLocaleDataBase));
  }

  _saveDataInLocalStorage(String jsonData, String localStorageKeyName) {
    try {
      List listOfUsers = jsonDecode(jsonData);
      List userlist = User.filterUserListData(listOfUsers);
      Prefs.setString(localStorageKeyName, jsonEncode(userlist));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  connectionCheckerCloser() {
    listener.cancel();
  }

  _updateCustomers() async {
    String customerData =
        await SqlConn.readData("SELECT CustID , CustName from dbo.T_Customers");
    List<Customer> customers =
        Customer.fromJsonStringListToCustomerList(customerData);
    for (var i = 0; i < customers.length; i++) {
      String customerBranches = await SqlConn.readData(
          "SELECT * from dbo.T_Branch WHERE F_Cust_Id = ${customers[i].CustID}");
      customers[i].CustomerBranches.addAll(
          CustomerBranch.fromJsonStringListToCustomerBranchList(
              customerBranches));
    }
    Prefs.setString(
        customersInfo, Customer.fromCustomerListToJsonListString(customers));
  }

  _updateCurrency() async {
    String currencyData =
        await SqlConn.readData("SELECT F_CURRANCY_ID , F_CURRANCY_NAM from dbo.T_CURRANCY ORDER BY F_CURRANCY_ID ASC");
    List<Currency> currency =
        Currency.fromJsonStringListToCurrencyList(currencyData);

    Prefs.setString(
        currencyInfo, Currency.fromCurrencyListToJsonListString(currency));
  }

    _updateBank() async {
    String currencyData =
        await SqlConn.readData("SELECT F_CURRANCY_ID , F_CURRANCY_NAM from dbo.T_CURRANCY ORDER BY F_CURRANCY_ID ASC");
    List<Currency> currency =
        Currency.fromJsonStringListToCurrencyList(currencyData);

    Prefs.setString(
        currencyInfo, Currency.fromCurrencyListToJsonListString(currency));
  }
}
