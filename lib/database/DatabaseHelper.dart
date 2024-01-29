import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../AnimalData.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<void> insertAnimal(AnimalData animalData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(animalData.id, animalData.smashValue);
  }

  Future<Map<String, String>> getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, String> animalDataMap = {};

    prefs.getKeys().forEach((key) {
      animalDataMap[key] = prefs.getString(key)!;
    });

    return animalDataMap;
  }

  Future<void> logAllSwipedData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Set<String> keys = prefs.getKeys();

    for (String key in keys) {
      final String? value = prefs.getString(key);
      if (value != null) {
        print('$key: $value');
      }
    }
  }

  Future<int> getSmashCount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int count = 0;

    final Map<String, String> allSwipedData =
        prefs.getKeys().fold<Map<String, String>>(
      {},
      (map, key) {
        final String swipeValue = prefs.getString(key)!;
        if (swipeValue == 'smash') {
          count++;
        }
        return map;
      },
    );
    return count;
  }

  Future<int> getPassCount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int count = 0;

    final Map<String, String> allSwipedData =
        prefs.getKeys().fold<Map<String, String>>(
      {},
      (map, key) {
        final String swipeValue = prefs.getString(key)!;
        if (swipeValue == 'pass') {
          count++;
        }
        return map;
      },
    );
    return count;
  }
}
