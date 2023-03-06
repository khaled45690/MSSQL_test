// ignore_for_file: file_names, invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sql_conn/sql_conn.dart';

import '../../Utilities/Prefs.dart';
import '../../Utilities/Strings.dart';
import '../UserData/User.dart';


bool? isssssssConnected ;
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
}
