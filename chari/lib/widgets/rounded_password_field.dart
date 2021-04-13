import 'package:chari/utility/utility.dart';
import 'package:chari/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RoundedPasswordField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final IconData icon;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final Function switchObscureTextMode;
  final Function onTapClearIcon;
  const RoundedPasswordField({
    Key key,
    this.hintText,
    this.obscureText,
    this.icon,
    this.controller,
    this.switchObscureTextMode,
    this.onTapClearIcon,
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
            size: 16,
            color: kPrimaryHighLightColor,
          ),
          suffixIcon: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
            mainAxisSize: MainAxisSize.min, // added line
            children: <Widget>[
              IconButton(
                padding: EdgeInsets.only(right: 0),
                splashRadius: 18,
                iconSize: 15,
                icon: FaIcon(FontAwesomeIcons.solidTimesCircle),
                onPressed: onTapClearIcon,
              ),
              IconButton(
                padding: EdgeInsets.only(right: 0),
                splashRadius: 18,
                iconSize: 16,
                icon: Icon(obscureText==true?FontAwesomeIcons.lowVision:FontAwesomeIcons.solidEye),
                onPressed: switchObscureTextMode,
              ),
            ],
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
