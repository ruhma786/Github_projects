import 'package:flutter/material.dart';
class GenderCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;

  GenderCard({required this.label, required this.icon, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: isSelected ? Color(0xFF1D1E33) : Color(0xFF111328),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80.0,
            color: Colors.white,
          ),
          SizedBox(height: 15.0),
          Text(
            label,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
