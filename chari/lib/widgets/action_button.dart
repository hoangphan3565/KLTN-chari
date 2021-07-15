import 'package:chari/utility/utility.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final bool selected;
  final Function onPressed;
  final double width;
  final double height;
  final double borderWidth;
  final Color borderColor;
  final double borderRadius;
  final Color buttonColor;
  final String buttonText;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  const ActionButton({
    Key key,
    this.text,
    this.selected,
    this.onPressed,
    this.width,
    this.height=40,
    this.borderWidth=1,
    this.borderColor=kPrimaryHighLightColor,
    this.borderRadius=5,
    this.buttonColor=Colors.white,
    this.buttonText,
    this.textColor=kPrimaryHighLightColor,
    this.fontSize=14,
    this.fontWeight=FontWeight.normal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(width: borderWidth, color: borderColor),
        borderRadius: BorderRadius.circular(borderRadius), color: buttonColor,
      ),
      child:FlatButton(
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: textColor),
        ),
      ),
    );
  }
}
