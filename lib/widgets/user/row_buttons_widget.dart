import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/utils/dimensions.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:flutter/material.dart';

import '../custom_decorated_grey_container.dart';

class RowButtonsWidget extends StatelessWidget {
  final Function _firstButtonOnPressed;
  final Function _secondButtonOnPressed;
  final int _rights;

  RowButtonsWidget({
    Key key,
    @required Function firstButtonOnPressed,
    @required Function secondButtonOnPressed,
    @required int rights,
  })  : this._firstButtonOnPressed = firstButtonOnPressed,
        this._secondButtonOnPressed = secondButtonOnPressed,
        this._rights = rights,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _rights == 1
            ? CustomDecoratedGreyContainer(
                child: FlatButton.icon(
                  padding: EdgeInsets.all(Dimensions.size0),
                  onPressed: _firstButtonOnPressed,
                  icon: Icon(
                    Icons.person_add,
                    color: ColorHelper.darkBlue,
                    size: Dimensions.size24,
                  ),
                  splashColor: ColorHelper.transparent,
                  highlightColor: ColorHelper.transparent,
                  label: Text(
                    S.current.new_user,
                    style: Styles.darkBlueBold18,
                  ),
                ),
              )
            : SizedBox.shrink(),
        FlatButton.icon(
          onPressed: _secondButtonOnPressed,
          icon: Icon(
            Icons.exit_to_app,
            color: ColorHelper.darkBlue,
            size: Dimensions.size24,
          ),
          splashColor: ColorHelper.transparent,
          highlightColor: ColorHelper.transparent,
          label: Text(
            S.current.log_out,
            style: Styles.darkBlueBold18,
          ),
        ),
      ],
    );
  }
}
