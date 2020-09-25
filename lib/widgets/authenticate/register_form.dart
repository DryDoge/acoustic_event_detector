import 'package:acoustic_event_detector/data/repositories/auth_repository.dart';
import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/utils/dimensions.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:acoustic_event_detector/widgets/platform_alert_dialog.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  final Function _exitForm;

  const RegisterForm({
    Key key,
    @required Function exitForm,
  })  : this._exitForm = exitForm,
        super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final AuthRepository _auth = AuthRepository();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordAgainController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String email = '';
  String password = '';
  String _passwordAgain = '';
  String error = '';
  int rights = 0;

  void _showErrorDialog({@required String title, @required String message}) {
    showDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title,
        message,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              validator: (value) =>
                  value.isEmpty ? S.current.register_email_info : null,
              decoration: InputDecoration(labelText: S.current.email),
              onChanged: (value) {
                setState(() => email = value);
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              validator: (value) => value.length < 6
                  ? S.current.register_password_info_short
                  : null,
              decoration: InputDecoration(labelText: S.current.password),
              obscureText: true,
              onChanged: (value) {
                setState(() => password = value);
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _passwordAgainController,
              validator: (value) => value != password
                  ? S.current.register_password_info_short
                  : null,
              decoration: InputDecoration(labelText: S.current.password),
              obscureText: true,
              onChanged: (value) {
                setState(() => _passwordAgain = value);
              },
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.size20),
              ),
              color: ColorHelper.darkBlue,
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  dynamic result = await _auth.registerWithEmailAndPassword(
                    email: email.trim(),
                    password: password.trim(),
                    rights: rights,
                  );
                  widget._exitForm();
                  if (result == null) {
                    _showErrorDialog(
                      title: S.current.register_error_default,
                      message: S.current.register_info_default,
                    );
                  }
                } else {
                  if (password.length < 6) {
                    _showErrorDialog(
                      title: S.current.register_password_error_short,
                      message: S.current.register_password_info_short,
                    );
                  } else if (password != _passwordAgain) {
                    _showErrorDialog(
                      title: S.current.register_password_error_not_match,
                      message: S.current.register_password_info_not_match,
                    );
                  }
                  _passwordController.clear();
                  _passwordAgainController.clear();
                }
              },
              child: Text(
                S.current.register,
                style: Styles.lightBlueRegular16,
              ),
            ),
            FlatButton(
              onPressed: widget._exitForm,
              splashColor: ColorHelper.transparent,
              highlightColor: ColorHelper.transparent,
              child: Text(
                S.current.cancel,
                style: Styles.mediumBlueRegular14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
