import 'package:flutter/material.dart';

class OutlinedVillagerSquare extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final Color borderColor;

  OutlinedVillagerSquare(
      {required this.imageUrl,
      required this.width,
      required this.height,
      required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Image.network(imageUrl),
    );
  }
}
