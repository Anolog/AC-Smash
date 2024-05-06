import 'package:flutter/material.dart';

class FancyDialogueBlobs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1024,
      height: 300,
      child: Column(
        children: [
          BuildTopBlob(context),
          SizedBox(height: 10),
          BuildBottomBlob(context),
        ],
      ),
    );
  }

  Widget BuildTopBlob(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.075,
      decoration: BoxDecoration(
        color: Color(0xFFfdf8e3),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
        curve: Curves.easeInOutSine,
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 235, 26, 26),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget BuildBottomBlob(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.40,
      width: MediaQuery.of(context).size.width * 0.94,
      decoration: BoxDecoration(
        color: Color(0xFFfdf8e3),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
        curve: Curves.easeInOutSine,
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black, // Change to your desired color
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
    );
  }
}
