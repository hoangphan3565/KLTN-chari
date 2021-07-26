import 'package:flutter/material.dart';
class LabeledRadio extends StatelessWidget {
  const LabeledRadio({
    Key key,
    this.label,
    this.padding,
    this.groupValue,
    this.value,
    this.onChanged,
  }) : super(key: key);

  final String label;
  final EdgeInsets padding;
  final dynamic groupValue;
  final dynamic value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value != groupValue) {
          onChanged(value);
        }
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Radio(
              groupValue: groupValue,
              value: value,
              onChanged: (dynamic newValue) {
                onChanged(newValue);
              },
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}