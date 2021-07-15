import 'package:chari/utility/utility.dart';
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
  final ValueChanged<String> onSubmitted;
  final TextInputType keyboardType;
  final TextAlign textAlign;
  final FocusNode focusNode;
  const RoundedInputField({
    Key key,
    this.hintText,
    this.textAlign=TextAlign.left,
    this.keyboardType,
    this.controller,
    this.icon,
    this.showClearIcon=false,
    this.onTapClearIcon,
    this.onChanged,
    this.onSubmitted,
    this.focusNode
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        textAlign: textAlign,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        controller: controller,
        keyboardType: keyboardType,
        cursorColor: kPrimaryColor,
        focusNode: focusNode,
        decoration: InputDecoration(
          hintStyle: TextStyle(
            fontSize: 15,
            height: 1.5,
          ),
          icon: Icon(
            icon,
            size: 16,
            color: kPrimaryHighLightColor,
          ),
          suffixIcon: showClearIcon?
          IconButton(
              splashRadius: 18,
              iconSize: 15,
              onPressed: onTapClearIcon,
              icon: FaIcon(FontAwesomeIcons.solidTimesCircle,color: Colors.black38,)
          ):IconButton(
              splashRadius: 18,
              iconSize: 15,
              onPressed: ()=>{},
              icon: FaIcon(FontAwesomeIcons.solidTimesCircle,color: kPrimaryLightColor,)
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
