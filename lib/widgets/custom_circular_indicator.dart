import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:flutter/material.dart';

class CustomCircularIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(accentColor: ColorHelper.darkBlue),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 30.0,
          width: 30.0,
          child: CircularProgressIndicator(
            backgroundColor: ColorHelper.lightBlue,
          ),
        ),
      ),
    );
  }
}
