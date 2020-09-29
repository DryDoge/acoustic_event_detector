import 'dart:ui';

import 'package:acoustic_event_detector/data/models/user.dart';
import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/utils/dimensions.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:acoustic_event_detector/widgets/authenticate/register_form.dart';
import 'package:acoustic_event_detector/widgets/custom_decorated_grey_container.dart';
import 'package:acoustic_event_detector/widgets/user/info_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({
    Key key,
    @required this.addUser,
    @required this.exitRegistration,
  }) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();

  final bool addUser;
  final Function exitRegistration;
}

class _UserScreenState extends State<UserScreen> {
  final _controller = ScrollController();

  void _scrollDown(BuildContext context) {
    if (widget.addUser) {
      _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: Duration(milliseconds: 600),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () => _scrollDown(context));
    return Container(
      height: Dimensions.max,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            ColorHelper.darkBlue,
            ColorHelper.lightBlue,
            ColorHelper.mediumBlue,
            ColorHelper.darkBlue,
          ],
          radius: 1.3,
          center: Alignment(0.6, -0.3),
          focal: Alignment(0.3, 0.1),
        ),
      ),
      child: SingleChildScrollView(
        controller: _controller,
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.size16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InfoWidget(user: Provider.of<User>(context, listen: false)),
              SizedBox(height: Dimensions.size10),
              widget.addUser
                  ? Card(
                      elevation: Dimensions.size6,
                      color: ColorHelper.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimensions.size20),
                      ),
                      child: CustomDecoratedGreyContainer(
                        child: Column(
                          children: [
                            Text(
                              S.current.user_create_new,
                              style: Styles.darkBlueBold20,
                            ),
                            RegisterForm(
                              exitForm: widget.exitRegistration,
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              SizedBox(height: Dimensions.size70),
            ],
          ),
        ),
      ),
    );
  }
}
