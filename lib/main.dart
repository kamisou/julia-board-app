import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:julia_board/board/presentation/screen/board_screen.dart';
import 'package:julia_board/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDependencies();
  await GoogleFonts.pendingFonts([GoogleFonts.outfitTextTheme()]);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const BoardScreen(),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color(0xFFB884CC),
        ),
        textTheme: GoogleFonts.outfitTextTheme(),
      ),
    );
  }
}
