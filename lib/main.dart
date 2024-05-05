import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SoundManager.dart';
import 'database/DatabaseHelper.dart';
import 'firebase_options.dart';
import 'smash_page.dart';

String userId = "anonymous";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();

  String? storedUserId = await DatabaseHelper().generateAndSaveUserId();
  prefs.setString('userId', storedUserId);

  SoundManager().initialize();

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
