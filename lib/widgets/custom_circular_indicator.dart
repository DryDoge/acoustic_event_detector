import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/utils/dimensions.dart';
import 'package:flutter/material.dart';

class CustomCircularIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(accentColor: ColorHelper.darkBlue),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.size10),
        child: CircularProgressIndicator(
          backgroundColor: ColorHelper.lightBlue,
        ),
      ),
    );
  }
}
