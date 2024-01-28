import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database/DatabaseHelper.dart';
import 'smash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AC Smash or Pass',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SwipeCardsPage(),
    );
  }
}
