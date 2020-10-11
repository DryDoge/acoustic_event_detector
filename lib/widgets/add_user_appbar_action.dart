import 'package:acoustic_event_detector/data/models/user.dart';
import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddUserAppBarAction extends StatelessWidget {
  final Function _onPressed;
  final Color _color;

  AddUserAppBarAction({
    Key key,
    @required Function onPressed,
    Color color,
  })  : this._onPressed = onPressed,
        this._color = color,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider.of<User>(context, listen: false).rights == 1
        ? IconButton(
            onPressed: _onPressed,
            icon: Icon(
              Icons.group_add,
              color: _color ?? ColorHelper.white,
              size: 14.0,
            ),
            splashColor: ColorHelper.transparent,
            highlightColor: ColorHelper.transparent,
          )
        : SizedBox.shrink();
  }
}
