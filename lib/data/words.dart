// lib/data/song_data.dart

import '../services/firebase_service.dart';

class SongData {
  // Use the Firebase service to get the dictionary
  static Map<String, String> get songDictionary => SongDataService().songDictionary;

  // Get all songs as a list (for random selection)
  static List<String> get taylorSwiftSongs => SongDataService().taylorSwiftSongs;
}