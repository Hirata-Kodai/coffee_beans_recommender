import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const BeanAdvisorApp());
}

class BeanAdvisorApp extends StatelessWidget {
  const BeanAdvisorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bean Advisor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6F4E37), // コーヒーブラウン
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'sans-serif',
      ),
      home: const HomeScreen(),
    );
  }
}
