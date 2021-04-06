import 'file:///D:/HCMUTE/HK8/KLTN-chari/chari/lib/utility/constants.dart';
import 'package:chari/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool showClearIcon;
  final Function onTapClearIcon;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  final TextAlign textAlign;
  const RoundedInputField({
    Key key,
    this.hintText,
    this.textAlign=TextAlign.left,
    this.keyboardType,
    this.controller,
    this.icon,
    this.showClearIcon,
    this.onTapClearIcon,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        textAlign: textAlign,
        onChanged: onChanged,
        controller: controller,
        keyboardType: keyboardType,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            size: 16,
            color: kPrimaryColor,
          ),
          suffixIcon: IconButton(
              splashRadius: 18,
              iconSize: 15,
              onPressed: onTapClearIcon,
              icon: FaIcon(FontAwesomeIcons.solidTimesCircle)
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
