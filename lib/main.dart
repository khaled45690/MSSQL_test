import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sql_conn/sql_conn.dart';
import 'package:sql_test/StateManagement/InternetState/InternetStateHandler.dart';
import 'package:sql_test/StateManagement/JourneyData/Journey.dart';
import 'package:sql_test/StateManagement/JourneyData/JourneyData.dart';
import 'package:sql_test/Utilities/Prefs.dart';
import 'package:sql_test/src/Feature/JourneyScreen/JourneyScreen.dart';

import 'StateManagement/UserData/User.dart';
import 'StateManagement/UserData/UserData.dart';
import 'src/Feature/LoginScreen/LoginScreen.dart';

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
  @override
  void initState() {
    super.initState();
    user = context.read<UserCubit>().getUserDataFromPref();
    
    Prefs.staticName = "staticUser";
    debugPrint("Prefs().name.toString()");
    debugPrint(Prefs().name.toString());
    debugPrint(Prefs.staticName);
    isssssssConnected = true;
    debugPrint("Prefs().name.toString()ss");
    debugPrint(isssssssConnected.toString());
     setConnectionssss(false);
    debugPrint(isssssssConnected.toString());
    debugPrint("Prefs().name.toString()ss");
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
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MaterialApp(
        title: "Don't know yet",
        theme: ThemeData(),
        initialRoute: user == null ? '/LoginScreen' : '/JourneyScreen',
        routes: {
          '/LoginScreen': (context) => const LoginScreen(),
          '/JourneyScreen': (context) => const JourneyScreen(),
        },
      ),
    );
  }
}
