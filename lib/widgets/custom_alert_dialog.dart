import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:flutter/material.dart';

enum CustomAction { First, Second }

class CustomAlertDialog extends StatelessWidget {
  final String _title;
  final Widget _message;
  final bool _oneOptionOnly;
  final bool _onlySecondImportant;
  final bool _onlyFirstImportant;

  CustomAlertDialog({
    Key key,
    @required String title,
    Widget message,
    bool oneOptionOnly,
    bool onlySecondImportant,
    bool onlyFirstImportant,
  })  : this._title = title,
        this._message = message,
        this._oneOptionOnly = oneOptionOnly ?? true,
        this._onlySecondImportant = onlySecondImportant ?? false,
        this._onlyFirstImportant = onlyFirstImportant ?? false,
        super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    onPressed: () => Navigator.pop(context, CustomAction.First),
                  ),
                  SizedBox(height: 12.0),
                  FlatButton(
                    child: Text(
                      S.current.no,
                      style: _onlyFirstImportant
                          ? Styles.defaultGreyRegular18
                          : Styles.darkBlueRegular18,
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
