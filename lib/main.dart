import 'package:flutter/material.dart';
import 'package:julia_board/board/presentation/screen/board_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const BoardScreen(),
      theme: ThemeData.light(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFFFAFAFC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB884CC),
          surfaceContainer: const Color(0xFFFFFFFF),
        ),
      ),
    );
  }
}
