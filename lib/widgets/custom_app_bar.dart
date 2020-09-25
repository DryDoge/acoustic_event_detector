import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/utils/dimensions.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String _title;
  final List<Widget> _actions;
  final Color _color;

  const CustomAppBar({
    Key key,
    final String title,
    final List<Widget> actions,
    final color,
  })  : this._title = title,
        this._actions = actions,
        this._color = color,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: _color ?? ColorHelper.mediumBlue,
      centerTitle: true,
      title: Text(
        _title ?? '',
        style: Styles.darkBlueBold20,
      ),
      elevation: Dimensions.size0,
      actions: _actions ?? [],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
