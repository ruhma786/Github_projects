import 'package:flutter/material.dart';
import 'constant.dart';
class RepeatTextandIconCode extends StatelessWidget {
  RepeatTextandIconCode({required this.iconData,required this.label});
  final IconData iconData;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          iconData,
          size: 85.8,
        ),
        SizedBox(
          height:15.0,
        ),
        Text(
          label,
          style:kLabelstyle,
        ),
      ],
    );
  }
}
