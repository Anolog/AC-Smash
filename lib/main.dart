import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database/DatabaseHelper.dart';
import 'smash_page.dart';

String userId = "anonymous";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //await prefs.clear();

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
