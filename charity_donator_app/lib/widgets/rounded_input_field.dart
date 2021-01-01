import 'package:charity_donator_app/constants.dart';
import 'package:charity_donator_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool showClearIcon;
  final Function onTopClearIcon;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  const RoundedInputField({
    Key key,
    this.hintText,
    this.keyboardType,
    this.controller,
    this.icon,
    this.showClearIcon,
    this.onTopClearIcon,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        controller: controller,
        keyboardType: keyboardType,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: kPrimaryColor,
          ),
          suffixIcon: IconButton(
            onPressed: onTopClearIcon,
            icon: Icon(Icons.close)
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
