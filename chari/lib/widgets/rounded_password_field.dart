import 'file:///D:/HCMUTE/HK8/KLTN-chari/chari/lib/utility/constants.dart';
import 'package:chari/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
            color: kPrimaryColor,
          ),
          suffixIcon: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
            mainAxisSize: MainAxisSize.min, // added line
            children: <Widget>[
              // InkWell(
              //     onTap: () {onTapClearIcon;},
              //     child: FaIcon(FontAwesomeIcons.timesCircle,size: 15,)),
              // InkWell(
              //     onTap: () {switchObscureTextMode;},
              //     child: Icon(obscureText==true?FontAwesomeIcons.low_vision:Icons.remove_red_eye_outlined,size: 18,)),
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
