# Swift Guess
<div align="center">
  <img src="assets/images/home_image.png" alt="Swift Guess Logo" width="200"/>
  <h3>A Taylor Swift song guessing game for Swifties of all levels</h3>
</div>

## 📥 Download
[Download APK](https://github.com/ashut0shj/swift_guess/releases/tag/v3.0)  
[Play Online](https://swift-guess.vercel.app/)

## 📱 About
Swift Guess is a Flutter-based mobile game where players test their knowledge of Taylor Swift songs by guessing titles letter by letter. With beautiful UI, multiple difficulty levels, and engaging gameplay, it provides entertainment for casual listeners and die-hard Swifties alike.

## ✨ Features
- **Engaging Gameplay**: Guess Taylor Swift song titles letter by letter
- **Multiple Difficulty Levels**: Choose between Easy, Medium, and Hard modes
- **Hint System**: Get song descriptions and reveal random letters
- **Score Tracking**: Compete against yourself with a high score system
- **Beautiful UI**: Enjoy a visually appealing interface with Taylor Swift-inspired colors
- **Offline Support**: Play without internet connection with cached song data
- **Taylor Swift Jingles**: Listen to Taylor Swift-inspired jingles while playing
- **Win/Lose Animations**: Experience confetti celebrations for wins and revealing animations for losses
- **Enhanced Haptic Feedback**: Feel vibrations when you lose the game
- **Cloud-Based Song Database**: Regular updates with new songs via Firebase
- **Persistent Data**: Your high scores are saved locally

## 🎮 How To Play
1. **Select a Difficulty Level**:
   - **Easy**: 8 hearts & 4 hints - Perfect for casual fans
   - **Medium**: 6 hearts & 3 hints - For the regular Swifties
   - **Hard**: 4 hearts & 2 hints - For the die-hard fans
2. **Guess the Song**:
   - Choose letters to reveal parts of the hidden song title
   - Each incorrect guess costs you one heart
   - Use hints to reveal song descriptions or random letters when you're stuck
   - Complete the title before running out of hearts
3. **Scoring System**:
   - Base score for each completed song
   - Bonus points for remaining hearts
   - Penalty for using hints
   - Try to beat your personal best!

## 🛠️ Technical Details
### Requirements
- Flutter SDK
- Dart
- Android Studio / Xcode (for deployment)

### Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.1.0
  flutter_animate: ^4.5.0
  confetti: ^0.8.0
  lottie: ^3.0.0
  shared_preferences: ^2.2.2
  audioplayers: ^6.4.0
  firebase_core: ^2.15.1
  cloud_firestore: ^4.9.1
  connectivity_plus: ^4.0.2
  firebase_auth: ^4.17.4
```

### Project Structure
```
lib/
├── main.dart
├── screens/
│   ├── home_screen.dart
│   ├── game_screen.dart
│   ├── how_to_play_screen.dart

├── data/
│   ├── words.dart
│   ├── score_repository.dart
│   └── song_data_service.dart
├── widgets/
│   ├── keyboard.dart
│   ├── word_display.dart
│   ├── hearts.dart
│   ├── game_options.dart
│   └── game_over_dialog.dart
├── jingle_player.dart
└── utils/
    └── ...
```

## 🔄 Data Management
- **Cloud Storage**: Song titles and hints stored in Firebase Firestore
- **Offline Caching**: Game works offline with locally cached song data
- **Fallback Data**: Default song list available if cloud fetch fails
- **Score Persistence**: High scores saved using SharedPreferences

## 🎵 Audio Features
- **Background Jingles**: Listen to Taylor Swift-inspired tunes while playing
- **Audio Controls**: Skip to the next jingle with a simple tap
- **Song Info**: View the currently playing jingle name

## 🚀 Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/swift-guess.git
   ```
2. Navigate to the project directory:
   ```bash
   cd swift-guess
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Set up Firebase:
   ```bash
   flutterfire configure
   ```
5. Run the app:
   ```bash
   flutter run
   ```

## 📚 Song Database
The game features an extensive collection of Taylor Swift songs from all eras:
- Debut
- Fearless
- Speak Now
- Red
- 1989
- Reputation
- Lover
- Folklore
- Evermore
- Midnights
- The Tortured Poets Department

With over 100 song titles and hints, even the biggest Swifties will be challenged!
