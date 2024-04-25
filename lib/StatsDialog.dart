import 'package:flutter/material.dart';

void showStatsDialog(
    BuildContext context, int passCount, int smashCount, bool completed) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                completed == true
                    ? "Congratulations, you are a degenerate!"
                    : "",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text("Your Passes: $passCount",
                  style: TextStyle(fontSize: 18, color: Colors.red)),
              Text("Your Smashes: $smashCount",
                  style: TextStyle(fontSize: 18, color: Colors.green)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Close"),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(0, 199, 165, 1.0),
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
