import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'jingle_player.dart';

void main() {
  
  try {
    
    WidgetsFlutterBinding.ensureInitialized();
    
    
    _playJingleSafely();
    
    
    runApp(const SwiftieGame());
  } catch (e) {
    
    print('Error in initialization: $e');
    runApp(MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF1E1B2E),
        body: Center(
          child: Text(
            'Something went wrong. Please restart the app.',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ));
  }
}


void _playJingleSafely() {
  try {
    JinglePlayer().play().catchError((e) {
      print('Jingle player error: $e');
    });
  } catch (e) {
    print('Error playing jingle: $e');
  }
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
        colorScheme: const ColorScheme.dark(
          primary: Colors.pinkAccent,
          secondary: Color(0xFF8A2BE2),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}