import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sql_test/MainWidgets/LoadingWidget.dart';
import 'package:sql_test/StateManagement/InternetState/InternetStateHandler.dart';
import 'package:sql_test/StateManagement/JourneyData/JourneyData.dart';
import 'package:sql_test/Utilities/Extentions.dart';

import '../../../MainWidgets/CustomButton.dart';
import '../../../Utilities/Colors.dart';
import 'Controller/JourneyScreenController.dart';
import 'Widgets/JourneyCard.dart';

class JourneyScreen extends StatefulWidget {
  const JourneyScreen({super.key});

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends JourneyScreenController {
  @override
  Widget build(BuildContext context) {
    outDatedLoginCheacker();
    return Scaffold(
      appBar: AppBar(backgroundColor: mainBlue),
      body: Stack(
        children: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomButton(
                        "ابدا رحلة",
                        150,
                        startNewJourney,
                        isEnabled: isStartEnabled,
                      ),
                      StreamBuilder(
                          stream: InternetConnectionCubit
                              .isConnectedToInternet.stream,
                          builder: (BuildContext context,
                              AsyncSnapshot<bool> isConnectedStream) {
                            bool isConnected = isConnectedStream.hasData
                                ? isConnectedStream.data!
                                : false;
                            debugPrint(
                                InternetConnectionCubit.isConnected.toString());
                            return CircleAvatar(
                                radius: 20,
                                backgroundColor:
                                    InternetConnectionCubit.isConnected
                                        ? Colors.green.shade800
                                        : Colors.red.shade800);
                          }),
                      CustomButton("انهاء الرحلة", 150, endTheJourney,
                          isEnabled: isEndEnabled),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: context.width() - 40,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: context.watch<JourneyCubit>().state.length,
                      itemBuilder: (BuildContext context, int i) {
                        bool isLastJourneyClosed =
                            context.watch<JourneyCubit>().state.length - 1 == i &&
                                context
                                    .watch<JourneyCubit>()
                                    .state[i]
                                    .isFinished;
                        debugPrint("isLastJourneyClosed.toString()");
                        debugPrint(isLastJourneyClosed.toString());
                        return JourneyCard(
                            context.watch<JourneyCubit>().state[i],
                            isLastJourneyClosed ? reOpenLastJourney : null);
                      },
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          LoadingWidget(isDataLoading)
        ],
      ),
    );
  }


}
