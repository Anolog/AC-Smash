import 'package:flutter/material.dart';
import 'OutlinedVillagerSquare.dart';
import 'FeedbackBar.dart';

class VillagerFeedbackWidget extends StatelessWidget {
  final String _villagerName;
  final String _imageURL;
  final int _smashCount;
  final int _passCount;

  VillagerFeedbackWidget(
      {required String pVillagerName,
      required String pImageURL,
      required int pPassCount,
      required int pSmashCount})
      : _passCount = pPassCount,
        _smashCount = pSmashCount,
        _imageURL = pImageURL,
        _villagerName = pVillagerName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "What others chose for $_villagerName...",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedVillagerSquare(
              pImageUrl: _imageURL,
              pWidth: 125,
              pWeight: 125,
              pBorderColor: Colors.white,
            ),
            SizedBox(width: 20),
            FeedbackBar(
              pLabel: "Smashes",
              pColor: Colors.green,
              pPercentage: (_passCount + _smashCount) != 0
                  ? ((_smashCount / (_passCount + _smashCount)) * 100).toInt()
                  : 0,
            ),
            SizedBox(width: 20),
            FeedbackBar(
              pLabel: "Passes",
              pColor: Colors.red,
              pPercentage: (_passCount + _smashCount) != 0
                  ? ((_passCount / (_passCount + _smashCount)) * 100).toInt()
                  : 0,
            ),
          ],
        ),
      ],
    );
  }
}
