import 'dart:ui';

import 'package:acoustic_event_detector/utils/dimensions.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:acoustic_event_detector/widgets/authenticate/register_form.dart';
import 'package:acoustic_event_detector/widgets/custom_decorated_grey_container.dart';
import 'package:acoustic_event_detector/widgets/user/info_widget.dart';
import 'package:acoustic_event_detector/widgets/user/row_buttons_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../data/blocs/cubit/auth_cubit.dart';
import '../../utils/color_helper.dart';
import '../../data/models/user.dart';
import '../../generated/l10n.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool _addUser = false;

  @override
  Widget build(BuildContext context) {
    final _authCubit = context.bloc<AuthCubit>();
    final User _user = Provider.of<User>(context, listen: false);
    final Size _size = MediaQuery.of(context).size;
    return Container(
      height: Dimensions.max,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topRight,
          colors: [
            ColorHelper.darkBlue,
            ColorHelper.mediumBlue,
            ColorHelper.lightBlue,
          ],
          radius: 1.4,
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.size16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InfoWidget(user: _user),
              SizedBox(height: Dimensions.size10),
              _addUser
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
                              exitForm: () => setState(() {
                                _addUser = false;
                              }),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox(
                      height:
                          _size.height * (_size.height > 600 ? 0.5152 : 0.40),
                    ),
              SizedBox(height: Dimensions.size20),
              RowButtonsWidget(
                rights: _user.rights,
                firstButtonOnPressed: () => setState(() => _addUser = true),
                secondButtonOnPressed: () async => _authCubit.logOutUser(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
