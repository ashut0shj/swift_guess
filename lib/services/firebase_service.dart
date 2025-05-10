import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SongDataService {
  // Singleton pattern
  static final SongDataService _instance = SongDataService._internal();
  factory SongDataService() => _instance;
  SongDataService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'taylor_swift_songs';
  final String _cacheKey = 'cached_songs';
  
  // Cached songs data
  Map<String, String> _songDictionary = {};
  
  // Get songs dictionary
  Map<String, String> get songDictionary => _songDictionary;
  
  // Get all songs as a list (for random selection)
  List<String> get taylorSwiftSongs => _songDictionary.keys.toList();

  // Initialize and load songs
  Future<void> initialize() async {
    try {
      // Check connectivity
      var connectivityResult = await Connectivity().checkConnectivity();
      bool hasInternet = connectivityResult != ConnectivityResult.none;
      
      if (hasInternet) {
        await _fetchFromFirebase();
      } else {
        await _loadFromCache();
      }
      
      // If dictionary is still empty, use default values
      if (_songDictionary.isEmpty) {
        _setDefaultSongs();
      }
    } catch (e) {
      print('Error initializing song data: $e');
      _setDefaultSongs();
    }
  }
  
  // Fetch songs from Firebase
  Future<void> _fetchFromFirebase() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection(_collectionName).get();
      
      Map<String, String> newSongs = {};
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String songName = data['name'] ?? '';
        String hint = data['hint'] ?? '';
        
        if (songName.isNotEmpty) {
          newSongs[songName] = hint;
        }
      }
      
      if (newSongs.isNotEmpty) {
        _songDictionary = newSongs;
        _saveToCache(newSongs);
      }
    } catch (e) {
      print('Error fetching from Firebase: $e');
      await _loadFromCache();
    }
  }
  
  // Save songs to local cache
  Future<void> _saveToCache(Map<String, String> songs) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String jsonData = jsonEncode(songs);
      await prefs.setString(_cacheKey, jsonData);
    } catch (e) {
      print('Error saving to cache: $e');
    }
  }
  
  // Load songs from local cache
  Future<void> _loadFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? jsonData = prefs.getString(_cacheKey);
      
      if (jsonData != null) {
        Map<String, dynamic> decodedData = jsonDecode(jsonData);
        Map<String, String> cachedSongs = {};
        
        decodedData.forEach((key, value) {
          cachedSongs[key] = value.toString();
        });
        
        if (cachedSongs.isNotEmpty) {
          _songDictionary = cachedSongs;
        }
      }
    } catch (e) {
      print('Error loading from cache: $e');
    }
  }
  
  // Set default songs as fallback
  void _setDefaultSongs() {
    _songDictionary = {
      'LOVER': 'Title track from her 2019 album with dreamy romantic lyrics',
      'BLANK SPACE': 'Famous line about "a long list of ex-lovers"',
    'SHAKE IT OFF': 'Upbeat anthem about ignoring the haters',
    'CRUEL SUMMER': 'Fan favorite from the Lover album with a screaming bridge',
    'ENCHANTED': 'A magical ballad about a fateful first meeting',
    'LOVE STORY': 'Modern retelling of Romeo and Juliet',
    'CARDIGAN': 'Folklore lead single with cozy, nostalgic imagery',
    'WILDEST DREAMS': 'Dreamy pop song about a fleeting romance',
    'RED': 'Passionate title track about love and heartbreak',
    'YOU BELONG WITH ME': 'Classic teen love story from Fearless',
    'ANTI HERO': 'Midnights hit with the line "It’s me, hi, I’m the problem"',
    'KARMA': 'Playful track about getting what you deserve',
    'BEJEWELED': 'Sparkling self-empowerment anthem from Midnights',
    'STYLE': 'Sleek 1989 hit rumored to be about Harry Styles',
    'DELICATE': 'Reputation era song about vulnerability in love',
    'THE ARCHER': 'Introspective Lover track about self-doubt',
    'THE MAN': 'Empowering anthem about double standards',
    'AUGUST': 'Folklore’s bittersweet summer love triangle song',
    'EXILE': 'Duet with Bon Iver about a painful breakup',
    'WILLOW': 'Evermore’s enchanting, mystical lead single',
    'CHAMPAGNE PROBLEMS': 'Evermore’s story of a rejected proposal',
    'CORNELIA STREET': 'Lover ballad about fearing the end of a relationship',
    'MINE': 'Upbeat Speak Now opener about finding lasting love',
    'OUR SONG': 'Debut era hit about a couple’s unique love story',
    'TEARDROPS ON MY GUITAR': 'Early heartbreak ballad from her debut',
    'BACK TO DECEMBER': 'Apology-filled ballad from Speak Now',
    'I KNEW YOU WERE TROUBLE': 'Dubstep-influenced Red single about regret',
    'FORTNIGHT': 'Emotional opener from The Tortured Poets Department',
    'DOWN BAD': 'TTPD track about feeling lost after heartbreak',
    'SO LONG LONDON': 'TTPD song about saying goodbye to a city and a love',
    'FLORIDA': 'TTPD track with Florence Welch about running away',
    'GUILTY AS SIN': 'TTPD song about forbidden attraction',
    'LOML': 'Acronym for "Love of My Life" from TTPD',
    'THE ALBATROSS': 'TTPD metaphor-rich song about burdens',
    'HOW DID IT END': 'TTPD reflective closer about a relationship’s demise',
    'THE PROPHECY': 'TTPD track pondering fate and destiny',
    'CASSANDRA': 'TTPD song referencing Greek mythology',
    'PETER': 'TTPD song with Peter Pan allusions',
    'AFTERGLOW': 'Lover track about taking the blame in a fight',
    'ALL TOO WELL': 'Fan-favorite Red ballad with vivid storytelling',
    'BREATHE': 'Fearless duet with Colbie Caillat about letting go',
    'CLEAN': '1989 closer about emotional renewal',
    'CLOSURE': 'Folklore track about unfinished business',
    'HOAX': 'Folklore’s somber, piano-driven finale',
    'INNOCENT': 'Speak Now song about forgiveness after scandal',
    'INVISIBLE': 'Debut album song about unrequited love',
    'MAROON': 'Midnights track about a deep, complicated romance',
    'MEAN': 'Speak Now anthem for the underdogs',
    'MIRRORBALL': 'Folklore track about adapting to please others',
    'SUBURBAN LEGENDS': '1989 (Taylor’s Version) vault track about lost love',
    'SUPERSTAR': 'Fearless song about crushing on a celebrity',
    'TREACHEROUS': 'Red ballad about dangerous attraction',
    'UNTILTED': 'TTPD track with a raw, confessional tone',
    'VIGILANTE SHIT': 'Midnights song about revenge and justice',
    'DEATH BY A THOUSAND CUTS': 'Lover song inspired by a movie breakup',
    'EVERMORE': 'Title track duet with Justin Vernon about moving on',
    'THE ONE': 'Folklore opener about “the one that got away”',
    'SEVEN': 'Folklore childhood nostalgia song',
    'HAPPINESS': 'Evermore’s mature take on moving forward',
    'PEACE': 'Folklore song about offering stability in love',
    'GOLD RUSH': 'Evermore track about envy and desire',
    'ITS TIME TO GO': 'Evermore bonus track about knowing when to leave',
    'TOLERATE IT': 'Evermore’s heartbreaking song about feeling unseen',
    'THIS LOVE': '1989’s atmospheric ballad about returning love',
    'BEGIN AGAIN': 'Red’s hopeful song about starting over',
    'STAY STAY STAY': 'Red’s playful, lighthearted love song',
    'NEW ROMANTICS': '1989 bonus track celebrating youth and freedom',
    'DAYLIGHT': 'Lover’s optimistic closing track',
    'CALL IT WHAT YOU WANT': 'Reputation love song about finding peace',
    'GETAWAY CAR': 'Reputation’s Bonnie & Clyde-inspired anthem',
    'DOROTHEA': 'Evermore’s ode to a small-town girl chasing dreams',
    'BETTY': 'Folklore’s apology from a teenage boy’s perspective',
    'MISS AMERICANA': 'Lover’s commentary on fame and politics',
    'LONG LIVE': 'Speak Now’s tribute to fans and memories',
    'THE STORY OF US': 'Speak Now’s energetic breakup song',
    'WHITE HORSE': 'Fearless’s ballad about fairy tales gone wrong',
    'SPARKS FLY': 'Speak Now’s electrifying love song',
    'DEAR JOHN': 'Speak Now’s epic breakup ballad',
    'HAUNTED': 'Speak Now’s dramatic, orchestral track',
    'OURS': 'Speak Now’s sweet, understated love song',
    'CHANGE': 'Fearless’s anthem about overcoming obstacles',
    'JUMP THEN FALL': 'Fearless Platinum Edition’s carefree love song',
    'FEARLESS': 'Title track about bold, young love',
    'HOLY GROUND': 'Red’s upbeat reflection on a past romance',
    'THE LAST TIME': 'Red duet with Gary Lightbody about a final chance',
    'KING OF MY HEART': 'Reputation’s declaration of true love',
    'I WISH YOU WOULD': '1989’s song about late-night regrets',
    'OUT OF THE WOODS': '1989’s urgent anthem about surviving chaos',
    'BAD BLOOD': '1989’s hit about betrayal and feuds',

    'ALL YOU HAD TO DO WAS STAY': '1989 track about a complicated relationship',
    'GORGEOUS': 'Reputation’s playful crush song',
    'HOW YOU GET THE GIRL': '1989’s advice on winning back love',
    'NEW YEARS DAY': 'Reputation’s emotional closing ballad',
    'PICTURE TO BURN': 'Debut era fiery breakup song',
    'READY FOR IT': 'Reputation’s dark, synth-heavy love song',
    'SAD BEAUTIFUL TRAGIC': 'Red’s melancholic ballad about lost love',
    'THIS IS WHY WE CANT HAVE NICE THINGS': 'Reputation’s cheeky song about betrayal',
    'UNTOUCHABLE': 'Fearless Platinum Edition’s ethereal love song',
    'WONDERLAND': '1989 bonus track inspired by Alice in Wonderland',
    };
  }
}