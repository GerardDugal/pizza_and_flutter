import 'package:flutter/material.dart';
import 'package:pizza_and_flutter/widget/start_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const StartScreen(title: 'Flutter Demo Home Page'),
    );
  }
}

