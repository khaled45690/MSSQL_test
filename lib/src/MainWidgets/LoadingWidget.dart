import 'package:flutter/material.dart' show BuildContext, Center, Colors, Container, Image, StatelessWidget, Widget;
import 'package:sql_test/src/Utilities/Extentions.dart';


class LoadingWidget extends StatelessWidget {
  final bool isDisconnected;
  const LoadingWidget(this.isDisconnected , {super.key});

  @override
  Widget build(BuildContext context) {
    return isDisconnected ? Container(
      width: context.width(),
      height: context.height(),
      color: Colors.blueGrey.withOpacity(0.3),
      child: Center(child:Image.asset("assets/images/loading.gif")),
    ):  Container();
  }
}
