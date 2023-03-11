// ignore_for_file: file_names, invalid_use_of_visible_for_testing_member

import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sql_test/Utilities/Strings.dart';

import '../../Utilities/Prefs.dart';
import '../../DataTypes/User.dart';

//BlocStateListener  BlocStateType
class UserCubit extends Cubit<User?> {
  // pass the initial value with super
  UserCubit() : super(null);

  // initialize UserData
  User? _userData;

  User? getUserData() {
    return _userData;
  }

  setUserData(User? userData) async {
    _userData = userData;
    emit(_userData);
    if (userData == null) return Prefs.remove(loginUserFromLocaleDataBase);
    Prefs.setString(loginUserFromLocaleDataBase, jsonEncode(_userData));
  }

  User? getUserDataFromPref() {
    String? userDataString = Prefs.getString(loginUserFromLocaleDataBase);
    if (userDataString == null) return null;
    Map data = jsonDecode(Prefs.getString(loginUserFromLocaleDataBase)!);
    _userData = User.fromJson(data);
    emit(_userData);
    return _userData;
  }
}
