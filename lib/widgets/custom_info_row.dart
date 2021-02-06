import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:flutter/material.dart';

class CustomInfoRow extends StatelessWidget {
  final String _title;
  final String _subtitle;

  const CustomInfoRow({
    Key key,
    @required String title,
    @required String subtitle,
  })  : this._title = title,
        this._subtitle = subtitle,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(_subtitle, style: Styles.mediumBlueRegular16),
        Text(_title, style: Styles.darkBlueBold18),
      ],
    );
  }
}
