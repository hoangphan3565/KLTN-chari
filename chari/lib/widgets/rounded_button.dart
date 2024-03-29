import 'package:chari/utility/utility.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final double fontsize;
  final Function press;
  final Color color, textColor;
  const RoundedButton({
    Key key,
    this.text,
    this.press,
    this.fontsize=16,
    this.color = kPrimaryColor,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      // padding: EdgeInsets.fromLTRB(0,10,0,10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
          color: color,
          onPressed: press,
          child: Text(
            text,
            style: TextStyle(color: textColor,fontSize: fontsize),
          ),
        ),
      ),
    );
  }
}
