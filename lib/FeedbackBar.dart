import 'package:flutter/material.dart';

class FeedbackBar extends StatelessWidget {
  final String label;
  final Color color;
  final int percentage;

  FeedbackBar(
      {required this.label, required this.color, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 5),
        Container(
          width: 10 + (percentage * 1.2),
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                // Adjust multiplier as needed
                child: Center(
                  child: Text(
                    "$percentage%",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
