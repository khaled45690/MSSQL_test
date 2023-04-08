import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sql_test/src/Utilities/Extentions.dart';

import '../../../StateManagement/JourneyData/JourneyData.dart';
import 'JourneyCard.dart';

class JourneiesList extends StatelessWidget {
  final Function() reOpenLastJourney;
  final Function() updateDataBase;
  const JourneiesList({super.key, required this.reOpenLastJourney , required this.updateDataBase});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width() - 40,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: context.watch<JourneyCubit>().state.length,
        itemBuilder: (BuildContext context, int i) {
          bool isLastJourneyClosed =
              context.watch<JourneyCubit>().state.length - 1 == i &&
                  context.watch<JourneyCubit>().state[i].isFinished;
          return JourneyCard(context.watch<JourneyCubit>().state[i],
              isLastJourneyClosed ? reOpenLastJourney : null , updateDataBase);
        },
      ),
    );
  }
}
