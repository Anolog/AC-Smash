import 'package:ac_smash/SpeechBlobArrow.dart';
import 'package:flutter/material.dart';
import 'AnimalNameComponent.dart';
import 'AnimalData.dart';

class AnimalCard extends StatelessWidget {
  final AnimalData animalData;

  AnimalCard({required this.animalData});

  IconData getHobbyIcon(String hobby) {
    switch (hobby.toLowerCase()) {
      case 'education':
        return Icons.school;
      case 'fashion':
        return Icons.shopping_bag;
      case 'fitness':
        return Icons.fitness_center;
      case 'music':
        return Icons.music_note;
      case 'nature':
        return Icons.eco;
      case 'play':
        return Icons.sports_soccer;
      default:
        return Icons.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 650,
      width: 550,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('AC-Background.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
        children: [
          // Animal Image loaded from URL
          Positioned(
            left: 100,
            top: 5,
            child: Image.network(
              animalData.animalImage,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Image.asset(
                    'assets/loading-placeholder.gif',
                    fit: BoxFit.contain,
                    width: 350,
                    height: 450,
                  );
                }
              },
              fit: BoxFit.contain,
              width: 350,
              height: 450,
            ),
          ),
          // Speech bubble container
          Positioned(
            left: 0,
            top: 460,
            child: Container(
              alignment: Alignment.center,
              width: 550,
              child: Image.asset('ACNH-Speech-Blob.png'),
            ),
          ),
          // Name Container
          Positioned(
            left: -15,
            top: 440,
            child: Container(
              padding: EdgeInsets.all(8),
              child: AnimalNameComponent(
                text: animalData.name,
                nameColor: animalData.nameColor,
                nameContainerColor: animalData.nameContainerColor,
              ),
            ),
          ),
          // Birthday Icon
          Positioned(
            top: 28,
            left: 37,
            child: Icon(
              Icons.cake,
              size: 75,
              color: Color.fromARGB(255, 180, 80, 80),
            ),
          ),
          // Birthday Text
          Positioned(
            top: 48,
            left: 47,
            child: Text(
              animalData.birthday,
              style: TextStyle(
                fontSize: 28,
                fontFamily: 'Hind',
                color: Color.fromARGB(255, 8, 8, 8),
              ),
            ),
          ),
          //Hobby Icon
          Positioned(
              top: 40,
              right: 47,
              child: Icon(
                getHobbyIcon(animalData.hobby),
                size: 50,
                color: Color.fromARGB(255, 180, 80, 80),
              )),
          // Favorite Saying
          Positioned(
            bottom: 50,
            left: 30,
            child: Container(
              width: 490,
              height: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text(
                    animalData.favoriteSaying,
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: 'Hind',
                      color: Color.fromARGB(255, 128, 114, 86),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 225,
            top: 570,
            child: Container(
              alignment: Alignment.center,
              child: SpeechBlobArrow(),
            ),
          ),
        ],
      ),
    );
  }
}
