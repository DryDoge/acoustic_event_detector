import 'package:acoustic_event_detector/data/models/custom_exception.dart';
import 'package:acoustic_event_detector/data/repositories/auth_repository.dart';
import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:acoustic_event_detector/widgets/custom_circular_indicator.dart';
import 'package:acoustic_event_detector/widgets/custom_alert_dialog.dart';
import 'package:acoustic_event_detector/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

enum Rights { Basic, All }

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

  final List<FocusNode> _focusNodes = [FocusNode(), FocusNode(), FocusNode()];
  final List<TextEditingController> _controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  String _email = '';
  String _password = '';
  String _passwordAgain = '';
  Rights _rights = Rights.Basic;

  bool get _selectedBasicRights {
    return _rights == Rights.Basic;
  }

  @override
  void initState() {
    super.initState();
    _focusNodes.forEach((node) {
      node.addListener(() {
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    _controllers.forEach((TextEditingController element) {
      element.dispose();
    });
    super.dispose();
  }

  void _showErrorDialog({@required String title, String message}) {
    showDialog(
      context: context,
      builder: (_) => CustomAlertDialog(
        title: title,
        message: Text(
          message ?? '',
          style: Styles.defaultGreyRegular14,
        ),
      ),
    );
  }

  Future<void> _validateAndTryRegister() async {
    try {
      if (_formKey.currentState.validate()) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  S.current.user_create_new_now,
                  style: Styles.darkBlueRegular16,
                ),
                CustomCircularIndicator(),
              ],
            ),
          ),
        );
        await _auth.registerWithEmailAndPassword(
          email: _email.trim(),
          password: _password.trim(),
          rights: _rights.index,
        );

        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (_) => CustomAlertDialog(
            title: S.current.register_success,
          ),
        );
        widget._exitForm();
      } else {
        if (_password.length < 6) {
          _showErrorDialog(
            title: S.current.register_password_error_short,
            message: S.current.register_password_info_short,
          );
        } else if (_password != _passwordAgain) {
          _showErrorDialog(
            title: S.current.register_password_error_not_match,
            message: S.current.register_password_info_not_match,
          );
        }
        for (int i = 1; i < _controllers.length; i++) {
          _controllers[i].clear();
        }
      }
    } on CustomException catch (error) {
      Navigator.pop(context);
      _showErrorDialog(title: error.message);
    } catch (error) {
      Navigator.pop(context);
      _showErrorDialog(
        title: S.current.error_default,
        message: S.current.register_info_default,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              focusNode: _focusNodes[0],
              labelText: S.current.email,
              icon: Icon(
                Icons.email_outlined,
                size: 30.0,
                color: _focusNodes[0].hasFocus
                    ? ColorHelper.darkBlue
                    : ColorHelper.defaultGrey,
              ),
              controller: _controllers[0],
              inputAction: TextInputAction.next,
              onChanged: (value) {
                setState(() => _email = value);
              },
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_focusNodes[1]),
              validator: (value) =>
                  value.isEmpty ? S.current.register_email_info : null,
            ),
            CustomTextField(
              controller: _controllers[1],
              labelText: S.current.password,
              focusNode: _focusNodes[1],
              obscureText: true,
              icon: Icon(
                Icons.lock_outline_rounded,
                size: 30.0,
                color: _focusNodes[1].hasFocus
                    ? ColorHelper.darkBlue
                    : ColorHelper.defaultGrey,
              ),
              inputAction: TextInputAction.next,
              validator: (value) => value.length < 6
                  ? S.current.register_password_info_short
                  : null,
              onChanged: (value) {
                setState(() => _password = value);
              },
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_focusNodes[2]),
            ),
            CustomTextField(
              controller: _controllers[2],
              labelText: S.current.password,
              focusNode: _focusNodes[2],
              obscureText: true,
              inputAction: TextInputAction.next,
              icon: Icon(
                Icons.lock_outline_rounded,
                size: 30.0,
                color: _focusNodes[2].hasFocus
                    ? ColorHelper.darkBlue
                    : ColorHelper.defaultGrey,
              ),
              validator: (value) => value != _password
                  ? S.current.register_password_error_not_match
                  : null,
              onChanged: (value) {
                setState(() => _passwordAgain = value);
              },
              onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
            ),
            RadioListTile(
              activeColor: ColorHelper.darkBlue,
              title: Text(
                '${S.current.rights_basic} ${S.current.rights.toLowerCase()}',
                style: _selectedBasicRights
                    ? Styles.darkBlueRegular16
                    : Styles.defaultGreyRegular16,
              ),
              secondary: Icon(
                Icons.done_rounded,
                color: _selectedBasicRights
                    ? ColorHelper.darkBlue
                    : ColorHelper.defaultGrey,
              ),
              value: Rights.Basic,
              groupValue: _rights,
              onChanged: (value) {
                FocusScope.of(context).unfocus();
                setState(() {
                  _rights = value;
                });
              },
            ),
            RadioListTile(
              activeColor: ColorHelper.darkBlue,
              title: Text(
                  '${S.current.rights_all} ${S.current.rights.toLowerCase()}',
                  style: !_selectedBasicRights
                      ? Styles.darkBlueRegular16
                      : Styles.defaultGreyRegular16),
              secondary: Icon(
                Icons.done_all_rounded,
                color: !_selectedBasicRights
                    ? ColorHelper.darkBlue
                    : ColorHelper.defaultGrey,
              ),
              value: Rights.All,
              groupValue: _rights,
              onChanged: (value) {
                FocusScope.of(context).unfocus();
                setState(() {
                  _rights = value;
                });
              },
            ),
            RaisedButton.icon(
              icon: Icon(
                Icons.add_circle_outline_rounded,
                color: ColorHelper.white,
                size: 30.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              color: ColorHelper.darkBlue,
              onPressed: () => _validateAndTryRegister(),
              label: Text(S.current.register, style: Styles.whiteRegular18),
            ),
            FlatButton.icon(
              icon: Icon(
                Icons.cancel_outlined,
                color: ColorHelper.defaultGrey,
                size: 18.0,
              ),
              onPressed: widget._exitForm,
              splashColor: ColorHelper.transparent,
              highlightColor: ColorHelper.transparent,
              label: Text(
                S.current.cancel,
                style: Styles.defaultGreyRegular14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
