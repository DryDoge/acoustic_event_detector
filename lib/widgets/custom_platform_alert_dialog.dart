import 'dart:io' show Platform;

import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/utils/dimensions.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum CustomAction { First, Second }

class CustomPlatformAlertDialog extends StatelessWidget {
  final String _title;
  final String _message;
  final bool _oneOptionOnly;

  CustomPlatformAlertDialog({
    Key key,
    @required String title,
    String message,
    bool oneOptionOnly,
  })  : this._title = title,
        this._message = message,
        this._oneOptionOnly = oneOptionOnly ?? true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Text(_title),
        content: _message != null ? Text(_message) : null,
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
                    SizedBox(height: Dimensions.size12),
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
        backgroundColor: ColorHelper.grey,
        title: Text(
          _title,
          style: Styles.darkBlueBold20,
        ),
        content: _message != null ? Text(_message) : null,
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
                        style: Styles.defaultGreyRegular18,
                      ),
                      onPressed: () =>
                          Navigator.pop(context, CustomAction.First),
                    ),
                    SizedBox(height: Dimensions.size12),
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
