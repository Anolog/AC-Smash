import 'package:flutter/material.dart';

class AnimalData {
  final String name;
  final String id;
  final String animalImage;
  final String backgroundImage;
  final Color nameColor;
  final Color nameContainerColor;
  final String birthday;
  final String favoriteSaying;
  final String hobby;
  final String smashValue = "";

  AnimalData({
    required this.name,
    required this.id,
    required this.animalImage,
    required this.backgroundImage,
    required this.nameColor,
    required this.nameContainerColor,
    required this.birthday,
    required this.favoriteSaying,
    required this.hobby,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'animalImage': animalImage,
      'backgroundImage': backgroundImage,
      'nameColor': nameColor.toString(),
      'nameContainerColor': nameContainerColor.toString(),
      'birthday': birthday,
      'favoriteSaying': favoriteSaying,
      'hobby': hobby,
      'smashValue': smashValue,
    };
  }
}
