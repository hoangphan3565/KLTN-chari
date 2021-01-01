import 'package:charity_donator_app/constants.dart';
import 'package:charity_donator_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class RoundedPasswordField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final IconData icon;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final Function onTapSuffixIcon;
  const RoundedPasswordField({
    Key key,
    this.hintText,
    this.obscureText,
    this.icon,
    this.controller,
    this.onTapSuffixIcon,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: hintText,
          icon: Icon(
            icon,
            color: kPrimaryColor,
          ),
          suffixIcon: IconButton(
            onPressed: onTapSuffixIcon,
            icon: Icon(obscureText==true?LineAwesomeIcons.low_vision:Icons.remove_red_eye_outlined),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
