import 'package:acoustic_event_detector/data/models/user.dart';
import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/utils/dimensions.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:acoustic_event_detector/widgets/custom_decorated_grey_container.dart';
import 'package:flutter/material.dart';

class InfoWidget extends StatelessWidget {
  final User _user;

  const InfoWidget({
    @required User user,
  }) : this._user = user;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: Dimensions.size6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.size20),
      ),
      child: CustomDecoratedGreyContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: Dimensions.size8),
                  child: Icon(
                    Icons.person,
                    color: ColorHelper.darkBlue,
                  ),
                ),
                Text(
                  '${S.current.user}:',
                  style: Styles.darkBlueBold20,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: Dimensions.size33),
              child: Text(
                _user.email,
                style: Styles.mediumBlueRegular18,
              ),
            ),
            SizedBox(height: Dimensions.size12),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: Dimensions.size8),
                  child: Icon(
                    Icons.settings_applications,
                    color: ColorHelper.darkBlue,
                  ),
                ),
                Text(
                  '${S.current.rights}:',
                  style: Styles.darkBlueBold20,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: Dimensions.size33),
              child: Text(
                _user.rights == 1
                    ? S.current.rights_all
                    : S.current.rights_basic,
                style: Styles.mediumBlueRegular18,
              ),
            )
          ],
        ),
      ),
    );
  }
}
