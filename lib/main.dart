import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'jingle_player.dart'; // import your jingle player

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ensures async init is ready
  JinglePlayer().play(); // start background music
  runApp(const SwiftieGame());
}

class SwiftieGame extends StatelessWidget {
  const SwiftieGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swiftie Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1E1B2E),
        textTheme: GoogleFonts.loraTextTheme(Theme.of(context).textTheme).apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
