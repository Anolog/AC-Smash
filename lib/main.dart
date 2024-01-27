import 'package:flutter/material.dart';
import 'smash_page.dart';

void main() {
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
