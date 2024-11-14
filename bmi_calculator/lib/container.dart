import 'package:flutter/material.dart';
class RepeatContainerCode extends StatelessWidget {
  RepeatContainerCode({required this.colors, this.cardwidget}); // Added a semicolon here
  final Color colors; // Marked as final for immutability
  final Widget? cardwidget;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      child: cardwidget,
      decoration: BoxDecoration(
        color: colors,
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}