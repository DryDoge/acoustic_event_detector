import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final TextInputType _inputType;
  final List<TextInputFormatter> _inputFormatters;
  const CustomTextField({
    Key key,
    @required FocusNode focusNode,
    TextEditingController controller,
    String Function(String) validator,
    void Function(String) onChanged,
    void Function(String) onFieldSubmitted,
    @required String labelText,
    TextInputAction inputAction,
    TextInputType inputType,
    List<TextInputFormatter> inputFormatters,
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
        this._inputType = inputType ?? TextInputType.text,
        this._inputFormatters = inputFormatters ?? null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            focusNode: _focusNode,
            controller: _controller,
            validator: _validator,
            textInputAction: _inputAction,
            keyboardType: _inputType,
            inputFormatters: _inputFormatters,
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
          ),
        ),
        SizedBox(width: 15.0),
        _focusNode.hasFocus
            ? Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: IconButton(
                  icon: Icon(Icons.cancel_outlined),
                  onPressed: () => _controller.clear(),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
