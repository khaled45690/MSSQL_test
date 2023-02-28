import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sql_conn/sql_conn.dart';
import 'package:sql_test/StateManagement/InternetState/InternetStateHandler.dart';
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
        ));
  }
}

void connectToDataBase() async {
  await SqlConn.connect(
      ip: "196.218.142.75",
      port: "1455",
      databaseName: "SWAT_2023",
      username: "sa",
      password: "bbs66666");

  String res = await SqlConn.readData(
      "SELECT * from dbo.T_Employee WHERE F_Prevlage = 3");
  // await SqlConn.writeData("Insert ${res.length},10 from dbo.. WHERE F_Prevlage = ${res.length}");
  String x = jsonEncode(res);
  List<User> userList = User.fromJsonStringListToUserList(res);
  await SqlConn.disconnect();
}
