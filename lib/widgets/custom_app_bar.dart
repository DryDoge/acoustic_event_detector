import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String _title;
  final List<Widget> _actions;
  final Color _color;
  final Widget _leading;

  const CustomAppBar({
    Key key,
    final String title,
    final List<Widget> actions,
    final Color color,
    final Widget leading,
  })  : this._title = title,
        this._actions = actions,
        this._color = color,
        this._leading = leading,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: _leading ?? null,
      backgroundColor: _color ?? ColorHelper.darkBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30.0),
        ),
      ),
      centerTitle: true,
      title: Text(
        _title ?? '',
        style: Styles.whiteBold20,
      ),
      elevation: 0.0,
      actions: _actions ?? [],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
