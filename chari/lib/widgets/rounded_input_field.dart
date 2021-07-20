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
  final int maxLines;
  final double hintSize;
  final IconData clearIcon;
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
    this.focusNode,
    this.maxLines=null,
    this.hintSize=15,
    this.clearIcon=FontAwesomeIcons.solidTimesCircle,
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
        maxLines: maxLines,
        decoration: InputDecoration(
          hintStyle: TextStyle(
            fontSize: hintSize,
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
              icon: FaIcon(clearIcon,color: Colors.black38,)
          ):null,
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
