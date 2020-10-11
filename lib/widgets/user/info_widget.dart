import 'package:acoustic_event_detector/data/models/user.dart';
import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:flutter/material.dart';

class InfoWidget extends StatelessWidget {
  final User _user;

  const InfoWidget({
    @required User user,
  }) : this._user = user;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.person,
                    color: ColorHelper.darkBlue,
                    size: 30.0,
                  ),
                ),
                Text(
                  '${S.current.user}:',
                  style: Styles.darkBlueBold20,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 32.0),
              child: Text(
                _user.email,
                style: Styles.defaultGreyRegular18,
              ),
            ),
            SizedBox(height: 12.0),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.settings_applications,
                    color: ColorHelper.darkBlue,
                    size: 30.0,
                  ),
                ),
                Text(
                  '${S.current.rights}:',
                  style: Styles.darkBlueBold20,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 32.0),
              child: Text(
                _user.rights == 1
                    ? S.current.rights_all
                    : S.current.rights_basic,
                style: Styles.defaultGreyRegular18,
              ),
            )
          ],
        ),
      ),
    );
  }
}
