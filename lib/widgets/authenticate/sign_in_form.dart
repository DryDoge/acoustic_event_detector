import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/screens/authenticate/cubit/auth_cubit.dart';
import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/utils/dimensions.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:acoustic_event_detector/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<FocusNode> _focusNodes = [FocusNode(), FocusNode()];
  final List<TextEditingController> _controllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  String _email = '';
  String _password = '';
  AuthCubit _authCubit;

  @override
  void dispose() {
    _controllers.forEach((TextEditingController element) {
      element.dispose();
    });
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _authCubit = context.bloc<AuthCubit>();
    _focusNodes.forEach((node) {
      node.addListener(() {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.size40,
        vertical: Dimensions.size20,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.size20),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.size20),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                ColorHelper.grey,
                ColorHelper.grey1,
                ColorHelper.grey2,
              ],
            ),
          ),
          padding: const EdgeInsets.all(Dimensions.size10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: Dimensions.size20),
                CustomTextField(
                  focusNode: _focusNodes[0],
                  labelText: S.current.email,
                  controller: _controllers[0],
                  inputAction: TextInputAction.next,
                  icon: Icon(
                    Icons.email_outlined,
                    size: Dimensions.size30,
                    color: _focusNodes[0].hasFocus
                        ? ColorHelper.darkBlue
                        : ColorHelper.defaultGrey,
                  ),
                  validator: (value) =>
                      value.isEmpty ? S.current.register_email_info : null,
                  onChanged: (value) {
                    setState(() => _email = value.trim());
                  },
                  onFieldSubmitted: (value) =>
                      FocusScope.of(context).requestFocus(_focusNodes[1]),
                ),
                CustomTextField(
                  labelText: S.current.password,
                  obscureText: true,
                  focusNode: _focusNodes[1],
                  controller: _controllers[1],
                  icon: Icon(
                    Icons.lock_outline_rounded,
                    size: Dimensions.size30,
                    color: _focusNodes[1].hasFocus
                        ? ColorHelper.darkBlue
                        : ColorHelper.defaultGrey,
                  ),
                  validator: (value) => value.length < 6
                      ? S.current.register_password_info_short
                      : null,
                  onChanged: (value) {
                    setState(() => _password = value.trim());
                  },
                  onFieldSubmitted: (_) {
                    if (_formKey.currentState.validate()) {
                      _authCubit.authenticateUser(_email, _password);
                    }
                  },
                ),
                SizedBox(height: Dimensions.size20),
                RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _authCubit.authenticateUser(_email, _password);
                    }
                  },
                  color: ColorHelper.lightBlue,
                  child: Text(
                    S.current.log_in,
                    style: Styles.darkBlueRegular16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
