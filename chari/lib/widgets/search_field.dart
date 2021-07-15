import 'package:chari/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool showClearIcon;
  final Function onTapClearIcon;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final TextInputType keyboardType;
  final TextAlign textAlign;
  const SearchField({
    Key key,
    this.hintText='Tìm kiếm',
    this.textAlign=TextAlign.left,
    this.keyboardType,
    this.controller,
    this.icon,
    this.showClearIcon,
    this.onTapClearIcon,
    this.onChanged,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.fromLTRB(0,10,0,10),
      padding: EdgeInsets.fromLTRB(0,0,0,0),
      width: size.width,
      height: size.height*0.055,
      decoration: BoxDecoration(
        color: Colors.black12.withOpacity(0.07),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.search,
        autofocus: true,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          // hintStyle: TextStyle(color: Colors.black38,fontSize: 16,height: 1.2),
          prefixIcon: Icon(Icons.search_rounded,color: Colors.black26),
          suffixIcon: showClearIcon?IconButton(
              splashRadius: 18,
              iconSize: 15,
              onPressed: onTapClearIcon,
              icon: FaIcon(FontAwesomeIcons.solidTimesCircle,color: Colors.black26)
          ):null,
        ),
        style: TextStyle(color: Colors.black, fontSize: 18.0),
        onChanged: onChanged,
        onSubmitted: onSubmitted,
      ),
    );
  }
}
