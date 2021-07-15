import 'package:chari/utility/utility.dart';
import 'package:chari/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SelectItem extends StatelessWidget {
  final String text;
  final bool selected;
  final Function onTapSelectItem;
  final double width;
  const SelectItem({
    Key key,
    this.text,
    this.selected,
    this.onTapSelectItem,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        GestureDetector(
          onTap: onTapSelectItem,
          child: Container(
            height: 40,
            width: width,
            margin: const EdgeInsets.only(bottom: 5.0),
            decoration: BoxDecoration(
                color: selected ? Colors.white:Colors.black12.withOpacity(0.02),
                borderRadius: BorderRadius.all(
                  Radius.circular(3),
                ),
                border: Border.all(
                  width: selected ? 1:0,
                  color: selected ? kPrimaryHighLightColor:Colors.white,
                )
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: selected ? kPrimaryHighLightColor : Colors.black87,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: -1,top: -1,
          child: selected? Icon(Icons.check_box_rounded, size: 15, color: kPrimaryHighLightColor)
              : Icon(Icons.check_box_outline_blank, size: 0, color: Colors.grey),
        ),
      ],
    );
  }
}
