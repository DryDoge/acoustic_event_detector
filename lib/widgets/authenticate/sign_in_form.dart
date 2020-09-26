import 'package:acoustic_event_detector/data/blocs/cubit/auth_cubit.dart';
import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/utils/dimensions.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  AuthCubit _authCubit;

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _authCubit = context.bloc<AuthCubit>();
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
                TextFormField(
                  controller: _emailController,
                  textInputAction: TextInputAction.next,
                  validator: (value) =>
                      value.isEmpty ? S.current.register_email_info : null,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorHelper.darkBlue),
                    ),
                    labelText: S.current.email,
                    focusColor: ColorHelper.darkBlue,
                  ),
                  cursorColor: ColorHelper.darkBlue,
                  onChanged: (value) {
                    setState(() => _email = value.trim());
                  },
                  onFieldSubmitted: (value) =>
                      FocusScope.of(context).requestFocus(_focusNode),
                ),
                SizedBox(height: Dimensions.size20),
                TextFormField(
                  focusNode: _focusNode,
                  controller: _passwordController,
                  validator: (value) => value.length < 6
                      ? S.current.register_password_info_short
                      : null,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorHelper.darkBlue),
                    ),
                    labelText: S.current.password,
                  ),
                  cursorColor: ColorHelper.darkBlue,
                  obscureText: true,
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
                  color: ColorHelper.mediumBlue,
                  child: Text(
                    S.current.log_in,
                    style: Styles.whiteRegular14,
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
