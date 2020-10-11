import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:flutter/material.dart';

class CustomFloatingButton extends StatelessWidget {
  final Function _onPressed;
  final Icon _icon;
  final String _label;

  CustomFloatingButton({
    Key key,
    @required Function onPressed,
    @required Icon icon,
    String label,
  })  : this._onPressed = onPressed,
        this._icon = icon,
        this._label = label,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: ColorHelper.darkBlue,
      onPressed: _onPressed,
      icon: _icon,
      label: Text(
        _label ?? '',
        style: Styles.whiteRegular12,
      ),
    );
  }
}
