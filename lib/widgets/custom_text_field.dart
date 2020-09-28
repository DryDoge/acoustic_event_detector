import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final FocusNode _focusNode;
  final TextEditingController _controller;
  final String Function(String) _validator;
  final String _labelText;
  final void Function(String) _onChanged;
  final void Function(String) _onFieldSubmitted;
  final TextInputAction _inputAction;
  final bool _obscureText;
  final Icon _icon;

  const CustomTextField({
    Key key,
    @required FocusNode focusNode,
    TextEditingController controller,
    String Function(String) validator,
    void Function(String) onChanged,
    void Function(String) onFieldSubmitted,
    @required String labelText,
    TextInputAction inputAction,
    Icon icon,
    bool obscureText,
  })  : this._focusNode = focusNode,
        this._controller = controller,
        this._validator = validator,
        this._labelText = labelText,
        this._onChanged = onChanged,
        this._onFieldSubmitted = onFieldSubmitted,
        this._inputAction = inputAction ?? TextInputAction.done,
        this._obscureText = obscureText ?? false,
        this._icon = icon ?? null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: _focusNode,
      controller: _controller,
      validator: _validator,
      textInputAction: _inputAction,
      decoration: InputDecoration(
        icon: _icon,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorHelper.darkBlue),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorHelper.defaultGrey),
        ),
        labelText: _labelText,
        labelStyle: _focusNode.hasFocus
            ? Styles.darkBlueRegular16
            : Styles.defaultGreyRegular16,
      ),
      cursorColor: ColorHelper.darkBlue,
      style: Styles.darkBlueRegular18,
      obscureText: _obscureText,
      onChanged: _onChanged,
      onFieldSubmitted: _onFieldSubmitted,
    );
  }
}
