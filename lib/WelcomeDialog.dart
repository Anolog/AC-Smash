import 'package:ac_smash/SoundManager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WelcomeDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color.fromARGB(255, 29, 29, 29),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome to Animal Crossing Smash or Pass!",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                "Created by Anolog (also known as Piemeup).",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                "Instructions:",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                "You can either click the buttons at the bottom to swipe for smashing or passing, or you can click and drag the card itself to the left or to the right. You cannot go back once you swipe - choose wisely! If you wish to view your swiping history, you can select the stats button.",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                "Special Thanks:",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 10),
              FutureBuilder(
                future: fetchSpecialThanks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error loading special thanks.",
                        style: TextStyle(color: Colors.red));
                  } else {
                    return Text(snapshot.data ?? "",
                        style: TextStyle(fontSize: 16, color: Colors.white));
                  }
                },
              ),
              SizedBox(height: 20),
              Text(
                "About:",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                "This page was created in part to learn Flutter/Dart to try out the language... I'm not the biggest fan... so because of that, this page might not work the best on mobile, it wasn't designed for it. If you want to design a mobile version of the page, feel free and I can incorporate it into the page, the github repo is open! (and horribly coded). Additionally - this was also inspired by Jimmyboy's Pokemon Smash or Pass. Check it out!",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                "Legal:",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                "Animal Crossing Smash or Pass, is a fan-made project and is not endorsed by or affiliated with Nintendo. Animal Crossing is a registered trademark of Nintendo. All trademarks and copyrights belong to their respective owners. Please support Nintendo by purchasing official Animal Crossing products.",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => {
                  Navigator.of(context).pop(),
                  SoundManager().playSoundOnce('Amazed')
                },
                child: Text("Close"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> fetchSpecialThanks() async {
    final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/Anolog/ac-smash/master/SpecialThanks.txt'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "Failed to fetch the Special Thanks list :(";
    }
  }
}
