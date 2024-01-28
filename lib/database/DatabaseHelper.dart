import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../AnimalData.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<void> insertAnimal(AnimalData animalData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String animalDataString = jsonEncode(animalData.toJson());

    await prefs.setString('animal_${animalData.id}', animalDataString);
  }

  Future<List<Map<String, dynamic>>> getAnimals() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<Map<String, dynamic>> animalList = [];

    final Map<String, String> allAnimalData =
        prefs.getKeys().fold<Map<String, String>>(
      {},
      (map, key) {
        if (key.startsWith('animal_')) {
          map[key] = prefs.getString(key)!;
        }
        return map;
      },
    );

    allAnimalData.forEach((key, value) {
      final Map<String, dynamic> animal = jsonDecode(value);
      animalList.add(animal);
    });

    return animalList;
  }
}
