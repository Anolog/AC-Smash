import 'package:flutter/material.dart';
import 'AnimalData.dart';
import 'OutlinedVillagerSquare.dart';

class StatsDialog extends StatefulWidget {
  final int passCount;
  final int smashCount;
  final bool completed;
  final Map<String, String> villagersSwiped;

  StatsDialog({
    required this.passCount,
    required this.smashCount,
    required this.completed,
    required this.villagersSwiped,
  });

  @override
  _StatsDialogState createState() => _StatsDialogState();
}

class _StatsDialogState extends State<StatsDialog> {
  List<MapEntry<String, String>> filteredEntries = [];

  @override
  void initState() {
    super.initState();
    filteredEntries = widget.villagersSwiped.entries.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        constraints: BoxConstraints(maxWidth: 600),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 49, 49, 49),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.completed == true
                  ? "Congratulations, you are a degenerate!"
                  : "",
              style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 221, 221, 221)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text("Your Passes: ${widget.passCount}",
                style: TextStyle(fontSize: 24, color: Colors.red)),
            Text("Your Smashes: ${widget.smashCount}",
                style: TextStyle(fontSize: 24, color: Colors.green)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Close"),
              style: ElevatedButton.styleFrom(
                primary: Color.fromRGBO(0, 199, 165, 1.0),
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0)),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildElevatedButton("Smash", () {
                  setState(() {
                    filteredEntries = widget.villagersSwiped.entries
                        .where((entry) => entry.value == 'smash')
                        .toList();
                  });
                }),
                SizedBox(width: 10),
                buildElevatedButton("Pass", () {
                  setState(() {
                    filteredEntries = widget.villagersSwiped.entries
                        .where((entry) => entry.value == 'pass')
                        .toList();
                  });
                }),
                SizedBox(width: 10),
                buildElevatedButton("All", () {
                  setState(() {
                    filteredEntries = widget.villagersSwiped.entries.toList();
                  });
                }),
              ],
            ),
            SizedBox(height: 20),
            Container(
              height: 500,
              width: 600,
              child: GridView.count(
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                crossAxisCount: 4,
                children: filteredEntries.map((entry) {
                  String imageUrl = entry.key;
                  String swipeValue = entry.value;
                  Color borderColor = swipeValue == 'smash'
                      ? Colors.green
                      : swipeValue == 'pass'
                          ? Colors.red
                          : Colors.transparent;
                  return OutlinedVillagerSquare(
                    imageUrl: imageUrl,
                    width: 50,
                    height: 50,
                    borderColor: borderColor,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ElevatedButton buildElevatedButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Text(
          text,
          style: TextStyle(fontSize: 26.0),
        ),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        primary: Color.fromRGBO(0, 199, 165, 1.0),
      ),
    );
  }
}
