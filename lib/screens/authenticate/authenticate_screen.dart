import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:flutter/material.dart';

import '../../widgets/authenticate/sign_in_form.dart';
import '../../widgets/custom_app_bar.dart';

class AuthenticateScreen extends StatelessWidget {
  static const routeName = '/authenticate';

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.center,
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
              colors: [
                ColorHelper.darkBlue,
                ColorHelper.mediumBlue,
                ColorHelper.mediumBlue,
                ColorHelper.mediumBlue,
                ColorHelper.mediumBlue,
                ColorHelper.darkBlue,
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Center(child: SignInForm()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
