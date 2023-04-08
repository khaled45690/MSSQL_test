// ignore_for_file: file_names, invalid_use_of_visible_for_testing_member

import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sql_test/src/Utilities/Strings.dart';

import '../../Utilities/Prefs.dart';
import '../../DataTypes/Journey.dart';

//BlocStateListener  BlocStateType
class JourneyCubit extends Cubit<List<Journey>> {
  // pass the initial value with super
  JourneyCubit() : super([]);

  // initialize journeyData
  List<Journey> _journeyData = [];

  List<Journey> getjourneyData() {
    return _journeyData;
  }

  setjourneyData(List<Journey> journeyData) async {
    emit([]);
    _journeyData = journeyData;
    emit(_journeyData);
  }

  setjourneyDataWithSharedPrefrence(List<Journey> journeyData) async {
    emit([]);
    _journeyData = journeyData;
    emit(_journeyData);
    Prefs.setString(userJouernies, Journey.fromJourneyListToJsonListString(_journeyData));
  }

  List<Journey> getJourneyDataFromPref() {
    emit([]);
    String? journeyDataString = Prefs.getString(userJouernies);
    if (journeyDataString == null) return [];
    _journeyData = Journey.fromJsonStringListToJourneyList(journeyDataString);
    emit(_journeyData);
    return _journeyData;
  }
}
