import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/screens/authenticate/cubit/auth_cubit.dart';
import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:acoustic_event_detector/widgets/custom_platform_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogoutAppBarAction extends StatelessWidget {
  const LogoutAppBarAction({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      label: Text(
        S.current.log_out,
        style: Styles.whiteRegular12,
      ),
      onPressed: () async {
        final result = await showDialog(
          context: context,
          builder: (context) => CustomPlatformAlertDialog(
            title: S.current.log_out_question,
            oneOptionOnly: false,
            onlySecondImportant: true,
          ),
        );
        if (result == CustomAction.First) {
          BlocProvider.of<AuthCubit>(context).logOutUser();
        }
      },
      icon: Icon(
        Icons.exit_to_app,
        color: ColorHelper.white,
        size: 24.0,
      ),
    );
  }
}
