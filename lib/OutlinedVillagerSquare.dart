import 'package:flutter/material.dart';

class OutlinedVillagerSquare extends StatelessWidget {
  final String imageUrl;

  OutlinedVillagerSquare({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 125,
      height: 125,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white70, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Image.network(imageUrl),
    );
  }
}
