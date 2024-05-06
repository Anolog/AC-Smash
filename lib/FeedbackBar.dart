import 'package:flutter/material.dart';

class FeedbackBar extends StatelessWidget {
  final String _label;
  final Color _color;
  final int _percentage;

  FeedbackBar(
      {required String pLabel, required Color pColor, required int pPercentage})
      : _percentage = pPercentage,
        _color = pColor,
        _label = pLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _label,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 5),
        Container(
          width: 15 + (_percentage * 1.2),
          height: 20,
          decoration: BoxDecoration(
            color: _color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 5,
                top: 0,
                bottom: 0,
                // Adjust multiplier as needed
                child: Center(
                  child: Text(
                    "$_percentage%",
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
