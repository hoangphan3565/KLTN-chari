import 'package:chari/utility/utility.dart';
import 'package:chari/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RoundedPasswordField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final bool showClearIcon;
  final IconData icon;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final Function switchObscureTextMode;
  final Function onTapClearIcon;
  final FocusNode focusNode;
  const RoundedPasswordField({
    Key key,
    this.hintText,
    this.obscureText,
    this.icon,
    this.controller,
    this.switchObscureTextMode,
    this.onTapClearIcon,
    this.showClearIcon=false,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        focusNode: focusNode,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 15,
            height: 1.5,
          ),
          icon: Icon(
            icon,
            size: 16,
            color: kPrimaryHighLightColor,
          ),
          suffixIcon: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                splashRadius: 18,
                iconSize: 16,
                icon: Icon(obscureText==true?FontAwesomeIcons.lowVision:FontAwesomeIcons.solidEye,color: Colors.black38,),
                onPressed: switchObscureTextMode,
              ),
              if(showClearIcon)
                IconButton(
                  splashRadius: 18,
                  iconSize: 15,
                  icon: FaIcon(FontAwesomeIcons.solidTimesCircle,color: Colors.black38,),
                  onPressed: onTapClearIcon,
                ),

            ],
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
