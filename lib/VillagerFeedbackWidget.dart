import 'package:flutter/material.dart';
import 'OutlinedVillagerSquare.dart';
import 'FeedbackBar.dart';

class VillagerFeedbackWidget extends StatelessWidget {
  final String villagerName;
  final String imageURL;
  final int smashCount;
  final int passCount;

  VillagerFeedbackWidget(
      {required this.villagerName,
      required this.imageURL,
      required this.passCount,
      required this.smashCount});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "What others chose for $villagerName...",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white70),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedVillagerSquare(
              imageUrl: imageURL,
              width: 125,
              height: 125,
              borderColor: Colors.white,
            ),
            SizedBox(width: 20),
            FeedbackBar(
              label: "Smashes",
              color: Colors.green,
              percentage: (passCount + smashCount) != 0
                  ? ((smashCount / (passCount + smashCount)) * 100).toInt()
                  : 0,
            ),
            SizedBox(width: 20),
            FeedbackBar(
              label: "Passes",
              color: Colors.red,
              percentage: (passCount + smashCount) != 0
                  ? ((passCount / (passCount + smashCount)) * 100).toInt()
                  : 0,
            ),
          ],
        ),
      ],
    );
  }
}
