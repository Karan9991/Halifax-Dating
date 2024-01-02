import 'package:flutter/material.dart';  
  


  Widget buildButton({
    required IconData icon,
    required VoidCallback onPressed,
    required double top,
    required double right,
    required Color color,
  }) {
    return Positioned(
      top: top,
      right: right,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 30,
            color: color, // Customize the button color
          ),
        ),
      ),
    );
  }