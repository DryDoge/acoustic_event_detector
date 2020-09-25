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

  String _email = '';
  String _password = '';

  void submitCredentials(BuildContext context, String email, String password) {
    final authCubit = context.bloc<AuthCubit>();
    authCubit.authenticateUser(email, password);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
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
            child: Column(
              children: [
                SizedBox(height: Dimensions.size20),
                TextFormField(
                  style: Styles.darkBlueRegular20,
                  controller: _emailController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorHelper.darkBlue),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorHelper.mediumBlue),
                    ),
                    labelText: S.current.email,
                    labelStyle: Styles.mediumBlueBold20,
                    focusColor: ColorHelper.darkBlue,
                  ),
                  cursorColor: ColorHelper.darkBlue,
                  onChanged: (value) {
                    setState(() => _email = value.trim());
                  },
                  onFieldSubmitted: (value) =>
                      FocusScope.of(context).requestFocus(_focusNode),
                ),
                SizedBox(height: 20),
                TextFormField(
                  focusNode: _focusNode,
                  style: Styles.darkBlueRegular20,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorHelper.darkBlue),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorHelper.mediumBlue),
                    ),
                    labelText: S.current.password,
                    labelStyle: Styles.mediumBlueBold20,
                  ),
                  cursorColor: ColorHelper.darkBlue,
                  obscureText: true,
                  onChanged: (value) {
                    setState(() => _password = value.trim());
                  },
                  onFieldSubmitted: (_) =>
                      submitCredentials(context, _email, _password),
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  onPressed: () =>
                      submitCredentials(context, _email, _password),
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
