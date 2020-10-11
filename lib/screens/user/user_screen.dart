import 'package:acoustic_event_detector/data/models/user.dart';
import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:acoustic_event_detector/widgets/user/register_form.dart';
import 'package:acoustic_event_detector/widgets/user/info_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatelessWidget {
  final bool addUser;
  final Function exitRegistration;
  const UserScreen({
    Key key,
    @required this.addUser,
    @required this.exitRegistration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InfoWidget(user: Provider.of<User>(context, listen: false)),
            SizedBox(height: 10.0),
            addUser
                ? Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      children: [
                        Text(
                          S.current.user_create_new,
                          style: Styles.darkBlueBold20,
                        ),
                        RegisterForm(
                          exitForm: exitRegistration,
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
