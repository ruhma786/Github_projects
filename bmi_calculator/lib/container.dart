import 'package:flutter/material.dart';

class RepeatContainerCode extends StatelessWidget {
  RepeatContainerCode({
    required this.colors,
    this.cardwidget,
    this.onPressed, // Made onPressed nullable
  });

  final Color colors;
  final Widget? cardwidget;
  final Function? onPressed; // Made nullable

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed != null ? () => onPressed!() : null, // Properly assigned onPressed
      child: Container(
        margin: const EdgeInsets.all(15.0),
        child: cardwidget,
        decoration: BoxDecoration(
          color: colors,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
