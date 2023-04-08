import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sql_conn/sql_conn.dart';
import 'package:sql_test/src/StateManagement/InternetState/InternetStateHandler.dart';
import 'package:sql_test/src/DataTypes/Journey.dart';
import 'package:sql_test/src/StateManagement/JourneyData/JourneyData.dart';
import 'package:sql_test/src/Utilities/Prefs.dart';
import 'package:sql_test/src/Feature/JourneyScreen/JourneyScreen.dart';

import 'src/DataTypes/User.dart';
import 'src/StateManagement/UserData/UserData.dart';
import 'src/Utilities/Strings.dart';
import 'WarningScreen.dart';
import 'src/Feature/AuthScreen/AuthScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  InternetConnectionCubit().connectionCheckerInitializer();
  await Prefs.init();
  runApp(MultiBlocProvider(providers: [
    BlocProvider<UserCubit>(
      create: (BuildContext context) => UserCubit(),
    ),
    BlocProvider<InternetConnectionCubit>(
      create: (BuildContext context) => InternetConnectionCubit(),
    ),
    BlocProvider<JourneyCubit>(
      create: (BuildContext context) => JourneyCubit(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user;
  bool isOutdatedlicence = false;
  @override
  void initState() {
    super.initState();
    Prefs.remove(currencyInfo);
    user = context.read<UserCubit>().getUserDataFromPref();

    if (user != null) {
      bool isOutdatedLogin = DateTime.now()
              .difference(DateTime.parse(user!.dateOfLogin!))
              .inMinutes >
          60;

      if (isOutdatedLogin) {
        user = null;
        context.read<UserCubit>().setUserData(null);
      }
    }
    if (DateTime.parse("2023-06-01 13:05:03.037527")
            .difference(DateTime.now())
            .inMinutes <=
        0) {
      isOutdatedlicence = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: isOutdatedlicence
          ? MaterialApp(
              title: "Don't know yet",
              theme: ThemeData(),
              home: const WarningScreen(),
            )
          : MaterialApp(
              title: "Don't know yet",
              theme: ThemeData(),
              initialRoute: user == null ? '/LoginScreen' : '/JourneyScreen',
              routes: {
                '/LoginScreen': (context) => const AuthScreen(),
                '/JourneyScreen': (context) => const JourneyScreen(),
              },
            ),
    );
  }
}
