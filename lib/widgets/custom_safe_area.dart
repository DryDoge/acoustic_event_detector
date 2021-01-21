import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:flutter/material.dart';

class CustomSafeArea extends StatelessWidget {
  final Widget _child;

  CustomSafeArea({
    Key key,
    @required Widget child,
  })  : this._child = child,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorHelper.darkBlue,
      child: SafeArea(
        child: _child,
      ),
    );
  }
}
