// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../MainWidgets/LoadingWidget.dart';
import '../../Utilities/Colors.dart';
import 'Controller/JourneyScreenController.dart';
import 'Widgets/JourneiesList.dart';
import 'Widgets/JourneyButtons.dart';

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
                  JourneyButtons(
                      isStartEnabled: isStartEnabled,
                      startNewJourney: startNewJourney,
                      isEndEnabled: isEndEnabled,
                      endTheJourney: endTheJourney),
                  const SizedBox(height: 30),
                  JourneiesList(reOpenLastJourney: reOpenLastJourney , updateDataBase: updateDataBase),
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
