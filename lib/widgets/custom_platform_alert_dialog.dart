import 'dart:io' show Platform;

import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum CustomAction { First, Second }

class CustomPlatformAlertDialog extends StatelessWidget {
  final String _title;
  final Widget _message;
  final bool _oneOptionOnly;
  final bool _onlySecondImportant;

  CustomPlatformAlertDialog({
    Key key,
    @required String title,
    Widget message,
    bool oneOptionOnly,
    bool onlySecondImportant,
  })  : this._title = title,
        this._message = message,
        this._oneOptionOnly = oneOptionOnly ?? true,
        this._onlySecondImportant = onlySecondImportant ?? false,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Text(_title),
        content: _message ?? Text(''),
        actions: [
          _oneOptionOnly
              ? CupertinoDialogAction(
                  child: Text(S.current.ok),
                  onPressed: () => Navigator.pop(context),
                )
              : Column(
                  children: [
                    CupertinoDialogAction(
                      child: Text(S.current.yes),
                      onPressed: () =>
                          Navigator.pop(context, CustomAction.First),
                    ),
                    SizedBox(height: 12.0),
                    CupertinoDialogAction(
                      child: Text(S.current.no),
                      onPressed: () =>
                          Navigator.pop(context, CustomAction.Second),
                    ),
                  ],
                ),
        ],
      );
    } else {
      return AlertDialog(
        title: Text(
          _title,
          style: Styles.darkBlueBold20,
        ),
        content: _message ?? Text(''),
        actions: [
          _oneOptionOnly
              ? FlatButton(
                  child: Text(
                    S.current.ok,
                    style: Styles.darkBlueRegular18,
                  ),
                  onPressed: () => Navigator.pop(context),
                )
              : Row(
                  children: [
                    FlatButton(
                      child: Text(
                        S.current.yes,
                        style: _onlySecondImportant
                            ? Styles.defaultGreyRegular18
                            : Styles.darkBlueRegular18,
                      ),
                      onPressed: () =>
                          Navigator.pop(context, CustomAction.First),
                    ),
                    SizedBox(height: 12.0),
                    FlatButton(
                      child: Text(
                        S.current.no,
                        style: Styles.darkBlueRegular18,
                      ),
                      onPressed: () =>
                          Navigator.pop(context, CustomAction.Second),
                    ),
                  ],
                ),
        ],
      );
    }
  }
}
