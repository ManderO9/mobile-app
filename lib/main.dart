import 'package:flutter/material.dart';
import 'package:imc/splashScreen.dart';
import 'Application/Application.dart';

// Main

void main() {
  Application.Init();
  runApp(const MyApp());
}

// Application

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
