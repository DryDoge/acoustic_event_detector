import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/utils/dimensions.dart';
import 'package:flutter/material.dart';

class CustomDecoratedGreyContainer extends StatelessWidget {
  final Widget _child;
  final EdgeInsetsGeometry _padding;

  CustomDecoratedGreyContainer({
    Key key,
    @required Widget child,
    EdgeInsetsGeometry padding,
  })  : this._child = child,
        this._padding = padding ?? EdgeInsets.all(Dimensions.size8),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.size20),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            ColorHelper.grey,
            ColorHelper.grey1,
            ColorHelper.grey2,
          ],
        ),
      ),
      child: _child,
    );
  }
}
