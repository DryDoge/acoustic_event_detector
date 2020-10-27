import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final String _title;
  final String _subtitle;

  const InfoRow({
    Key key,
    @required String title,
    @required String subtitle,
  })  : this._title = title,
        this._subtitle = subtitle,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      children: [
        Align(
          child: Text(_subtitle, style: Styles.mediumBlueRegular16),
          alignment: Alignment.centerLeft,
        ),
        Align(
          child: Text(_title, style: Styles.darkBlueBold18),
          alignment: Alignment.centerLeft,
        ),
      ],
    );
  }
}
