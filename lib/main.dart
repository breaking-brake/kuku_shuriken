import 'package:flutter/material.dart';

import 'presentation/screens/difficulty_screen.dart';

void main() {
  runApp(const KukuShurikenApp());
}

class KukuShurikenApp extends StatelessWidget {
  const KukuShurikenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '九九手裏剣',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const DifficultyScreen(),
    );
  }
}
