import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/widgets/custom_circular_indicator.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  static const routeName = '/loading';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ColorHelper.darkBlue,
              ColorHelper.mediumBlue,
              ColorHelper.mediumBlue,
              ColorHelper.mediumBlue,
              ColorHelper.darkBlue,
            ],
          ),
        ),
        child: Center(child: CustomCircularIndicator()),
      ),
    );
  }
}
