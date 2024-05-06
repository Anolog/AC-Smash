import 'package:flutter/material.dart';

class OutlinedVillagerSquare extends StatelessWidget {
  final String _imageUrl;
  final double _width;
  final double _height;
  final Color _borderColor;

  OutlinedVillagerSquare(
      {required String pImageUrl,
      required double pWidth,
      required double pWeight,
      required Color pBorderColor})
      : _borderColor = pBorderColor,
        _height = pWeight,
        _width = pWidth,
        _imageUrl = pImageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      height: _height,
      decoration: BoxDecoration(
        border: Border.all(color: _borderColor, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Image.network(_imageUrl),
    );
  }
}
