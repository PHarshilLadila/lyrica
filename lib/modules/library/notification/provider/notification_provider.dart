// import 'package:flutter/material.dart';
// import 'package:lyrica/modules/library/notification/service/notification_service.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:intl/intl.dart';

// class MusicNotificationProvider with ChangeNotifier {
//   final MusicNotificationService _notificationService =
//       MusicNotificationService();
//   bool _notificationsEnabled = false;

//   final Map<String, TimeOfDay> _reminderTimes = {
//     'morning': TimeOfDay(hour: 8, minute: 0),
//     'afternoon': TimeOfDay(hour: 11, minute: 0),
//     'evening': TimeOfDay(hour: 18, minute: 0),
//     'night': TimeOfDay(hour: 22, minute: 0),
//     'midnight': TimeOfDay(hour: 3, minute: 0),
//   };

//   bool get notificationsEnabled => _notificationsEnabled;

//   Future<void> init() async {
//     final prefs = await SharedPreferences.getInstance();
//     _notificationsEnabled = prefs.getBool('notifications_enabled') ?? false;
//     await _notificationService.init();

//     if (_notificationsEnabled) {
//       for (final period in _reminderTimes.keys) {
//         await _scheduleNotification(period);
//       }
//     }

//     notifyListeners();
//   }

//   Future<void> _scheduleNotification(String period) async {
//     final time = _reminderTimes[period]!;
//     final id = _getNotificationId(period);
//     await _notificationService.scheduleDailyNotification(time, period, id);
//   }

//   int _getNotificationId(String period) {
//     switch (period) {
//       case 'morning':
//         return 1;
//       case 'afternoon':
//         return 2;
//       case 'evening':
//         return 3;
//       case 'night':
//         return 4;
//       case 'midnight':
//         return 5;
//       default:
//         return 0;
//     }
//   }

//   Future<void> toggleNotifications(bool value) async {
//     final prefs = await SharedPreferences.getInstance();

//     if (value) {
//       final hasPermission = await _checkAndRequestNotificationPermission();
//       if (!hasPermission) {
//         _notificationsEnabled = false;
//         notifyListeners();
//         return;
//       }

//       for (final period in _reminderTimes.keys) {
//         await _scheduleNotification(period);
//       }
//     } else {
//       await _notificationService.cancelAllNotifications();
//     }

//     _notificationsEnabled = value;
//     await prefs.setBool('notifications_enabled', value);
//     notifyListeners();
//   }

//   Future<bool> _checkAndRequestNotificationPermission() async {
//     try {
//       if (await Permission.notification.isGranted) return true;
//       final status = await Permission.notification.request();
//       return status.isGranted;
//     } catch (e) {
//       debugPrint('Permission error: $e');
//       return false;
//     }
//   }

//   String formatTimeOfDay(TimeOfDay time) {
//     final now = DateTime.now();
//     final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
//     return DateFormat.jm().format(dt);
//   }
// }

import 'package:flutter/material.dart';
import 'package:lyrica/modules/library/notification/service/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

final List<Map<String, String>> notificationMessages = [
  // Morning notifications (40)
  {
    "title": "Good Morning 🌞",
    "body": "Start your day with fresh vibes in your morning playlist.",
  },
  {
    "title": "Rise and Shine 🎵",
    "body": "Your morning motivation mix is ready to energize your day!",
  },
  {
    "title": "Morning Tunes ☀️",
    "body": "Wake up to the perfect soundtrack for your day ahead.",
  },
  {
    "title": "Breakfast Beats 🥞",
    "body": "Fuel your morning with these energizing tracks.",
  },
  {
    "title": "Sunrise Melodies 🌅",
    "body": "Greet the day with these uplifting morning songs.",
  },
  {
    "title": "Daily Dose of Music ☕",
    "body": "Your morning coffee tastes better with these tunes.",
  },
  {
    "title": "Wake Up Worship 🙏",
    "body": "Start your day with inspirational gospel and worship songs.",
  },
  {
    "title": "Morning Motivation 💪",
    "body": "Get pumped for the day with these high-energy tracks.",
  },
  {
    "title": "Chill Morning Vibes 🍃",
    "body": "Ease into your day with these relaxing morning tunes.",
  },
  {
    "title": "Acoustic Awakening 🎸",
    "body": "Gentle acoustic songs to start your day peacefully.",
  },
  {
    "title": "Fresh Finds Friday 📅",
    "body": "New music discoveries to kickstart your weekend morning!",
  },
  {
    "title": "Yoga Harmony 🧘",
    "body": "Peaceful tunes for your morning stretch and meditation.",
  },
  {
    "title": "Commute Companion 🚗",
    "body": "Perfect playlist for your morning drive or transit.",
  },
  {
    "title": "Shower Singer's Delight 🚿",
    "body": "Morning anthems to belt out in the shower!",
  },
  {
    "title": "Productivity Beats 📊",
    "body": "Focus-enhancing music to start your workday right.",
  },
  {
    "title": "Morning Dance Party 💃",
    "body": "Get your body moving with these upbeat morning tracks.",
  },
  {
    "title": "Sunrise Serenade 🎶",
    "body": "Beautiful melodies to accompany the morning light.",
  },
  {
    "title": "Breakfast with Beethoven 🎹",
    "body": "Classical pieces to优雅地开始您的一天。",
  },
  {
    "title": "Jazz Morning ☕",
    "body": "Smooth jazz to accompany your morning routine.",
  },
  {
    "title": "Folk Awakening 🌄",
    "body": "Authentic folk tunes to start your day naturally.",
  },
  {
    "title": "Indie Morning 🌱",
    "body": "Discover fresh indie artists to begin your day.",
  },
  {
    "title": "Retro Revival 🌟",
    "body": "Classic hits to give your morning a nostalgic twist.",
  },
  {
    "title": "World Music Wake-up 🌍",
    "body": "Global sounds to broaden your morning horizons.",
  },
  {
    "title": "R&B Rise 🎤",
    "body": "Smooth R&B vocals to gently start your day.",
  },
  {
    "title": "Country Morning 🌄",
    "body": "Down-home country tunes for a rustic start.",
  },
  {
    "title": "Hip-Hop Breakfast 🎧",
    "body": "Fresh beats to fuel your morning swagger.",
  },
  {
    "title": "Electronic Sunrise ⚡",
    "body": "Energetic electronic music to jumpstart your day.",
  },
  {
    "title": "Rock Your Morning 🤘",
    "body": "Powerful rock anthems to shake off sleep.",
  },
  {
    "title": "Piano Daybreak 🎹",
    "body": "Beautiful piano compositions for a reflective morning.",
  },
  {
    "title": "Reggae Rise 🌴",
    "body": "Island vibes to start your day relaxed and positive.",
  },
  {
    "title": "K-Pop Morning 🌟",
    "body": "Energetic K-pop to add some sparkle to your morning.",
  },
  {
    "title": "Latin AM Ritmo 💃",
    "body": "Rhythmic Latin tunes to get your morning moving.",
  },
  {
    "title": "Soul Sunrise 🎤",
    "body": "Heartfelt soul music to nourish your morning spirit.",
  },
  {
    "title": "Metal Awakening ⚡",
    "body": "Powerful metal to aggressively start your day.",
  },
  {
    "title": "Blues Morning 🎷",
    "body": "Soulful blues to accompany your morning coffee.",
  },
  {
    "title": "Opera Dawn 🎭",
    "body": "Dramatic opera to make your morning majestic.",
  },
  {
    "title": "Ambient Awakening 🌫️",
    "body": "Atmospheric sounds for a gradual morning wake-up.",
  },
  {
    "title": "Funkify Your Morning 🕺",
    "body": "Groovy funk to get your body moving early.",
  },
  {
    "title": "Disco Daybreak 🌟",
    "body": "Sparkling disco tunes to make your morning fabulous.",
  },
  {
    "title": "Bluegrass Sunrise 🌄",
    "body": "Foot-stomping bluegrass for an energetic start.",
  },

  // Afternoon notifications (40)
  {
    "title": "Lunchtime Beats 🥪",
    "body": "Perfect soundtrack for your midday break.",
  },
  {
    "title": "Afternoon Escape 🎧",
    "body": "Take a musical break from your busy day.",
  },
  {
    "title": "Midday Motivation 💼",
    "body": "Beat the afternoon slump with these energizing tracks.",
  },
  {
    "title": "Productivity Playlist 📈",
    "body": "Focus-enhancing music for your afternoon work session.",
  },
  {
    "title": "Afternoon Acoustic 🎸",
    "body": "Relaxed acoustic tunes for a peaceful afternoon.",
  },
  {
    "title": "Sunshine Sounds 🌤️",
    "body": "Bright songs to match the afternoon sunshine.",
  },
  {
    "title": "Chill Afternoon Vibes 🍃",
    "body": "Laid-back tracks for a relaxing afternoon.",
  },
  {
    "title": "Coffee Break Tunes ☕",
    "body": "The perfect accompaniment to your afternoon pick-me-up.",
  },
  {
    "title": "Afternoon Dance Break 💃",
    "body": "Time to get up and move with these upbeat tracks!",
  },
  {
    "title": "Study Session 🎵",
    "body": "Concentration-boosting music for afternoon learning.",
  },
  {
    "title": "Workout Wave 🏋️",
    "body": "Energetic tunes for your afternoon exercise routine.",
  },
  {
    "title": "Creative Flow 🎨",
    "body": "Inspirational music to spark your afternoon creativity.",
  },
  {
    "title": "Afternoon Drive 🚗",
    "body": "Great tracks for your commute home or errand running.",
  },
  {
    "title": "Jazz Afternoon 🎷",
    "body": "Smooth jazz to sophisticate your afternoon.",
  },
  {
    "title": "Indie PM 🌼",
    "body": "Discover new indie artists for your afternoon listening.",
  },
  {
    "title": "Retro Afternoon 📻",
    "body": "Classic hits to give your afternoon nostalgic vibes.",
  },
  {
    "title": "World Sounds Expedition 🌍",
    "body": "Explore global music this afternoon.",
  },
  {
    "title": "R&B Groove 🎤",
    "body": "Smooth R&B to add style to your afternoon.",
  },
  {
    "title": "Country Afternoon 🌾",
    "body": "Down-home country for a relaxed afternoon.",
  },
  {
    "title": "Hip-Hop Hustle 🎧",
    "body": "Fresh beats to power through your afternoon tasks.",
  },
  {
    "title": "Electronic Energy ⚡",
    "body": "Energetic electronic music to combat afternoon fatigue.",
  },
  {
    "title": "Rock Revival 🤘",
    "body": "Powerful rock to reinvigorate your afternoon.",
  },
  {
    "title": "Piano Reflections 🎹",
    "body": "Beautiful piano music for thoughtful afternoon moments.",
  },
  {
    "title": "Reggae Relaxation 🌴",
    "body": "Island vibes to keep your afternoon chill.",
  },
  {
    "title": "K-Pop Boost 🌟",
    "body": "Energetic K-pop to brighten your afternoon.",
  },
  {
    "title": "Latin Rhythm Break 💃",
    "body": "Rhythmic Latin tunes to spice up your afternoon.",
  },
  {
    "title": "Soulful Afternoon 🎤",
    "body": "Heartfelt soul music for your midday moments.",
  },
  {
    "title": "Metal Charge ⚡",
    "body": "Powerful metal to aggressively attack your afternoon.",
  },
  {
    "title": "Blues Break 🎷",
    "body": "Soulful blues to accompany your afternoon reflection.",
  },
  {
    "title": "Opera Interlude 🎭",
    "body": "Dramatic opera to make your afternoon majestic.",
  },
  {
    "title": "Ambient Atmosphere 🌫️",
    "body": "Atmospheric sounds for afternoon focus or relaxation.",
  },
  {
    "title": "Funk Break 🕺",
    "body": "Groovy funk to get your body moving this afternoon.",
  },
  {
    "title": "Disco Daylight 🌟",
    "body": "Sparkling disco tunes to make your afternoon fabulous.",
  },
  {
    "title": "Bluegrass Break 🌄",
    "body": "Foot-stomping bluegrass for an energetic afternoon.",
  },
  {
    "title": "Podcast Playlist 🎙️",
    "body": "Music-themed podcasts for your afternoon listening.",
  },
  {
    "title": "Featured Artist Focus 🎤",
    "body": "Deep dive into an artist's discography this afternoon.",
  },
  {
    "title": "New Music Wednesday 📅",
    "body": "Fresh releases to discover this afternoon!",
  },
  {
    "title": "Throwback Thursday 📻",
    "body": "Nostalgic hits to celebrate the approaching weekend.",
  },
  {
    "title": "Weekend Warm-up 🎉",
    "body": "Get ready for the weekend with these Friday afternoon tunes!",
  },
  {
    "title": "Rainy Day Relaxation ☔",
    "body": "Cozy tunes for a quiet afternoon indoors.",
  },

  // Evening notifications (40)
  {
    "title": "Evening Wind-down 🌆",
    "body": "Relaxing tunes to unwind after a long day.",
  },
  {
    "title": "Sunset Sounds 🌇",
    "body": "Beautiful music to accompany the evening sky.",
  },
  {
    "title": "Dinner Party Vibes 🍽️",
    "body": "Perfect background music for your evening meal.",
  },
  {
    "title": "Evening Relaxation 🛋️",
    "body": "Calming songs to decompress from your day.",
  },
  {"title": "Night Drive 🚗", "body": "Atmospheric music for evening driving."},
  {
    "title": "Evening Acoustic 🎸",
    "body": "Gentle acoustic songs for a peaceful evening.",
  },
  {
    "title": "Cocktail Hour 🍸",
    "body": "Sophisticated tunes for your evening drink.",
  },
  {
    "title": "Evening Jazz 🎷",
    "body": "Smooth jazz to set a classy evening mood.",
  },
  {
    "title": "Indie Night 🌙",
    "body": "Discover moody indie artists for evening listening.",
  },
  {
    "title": "Evening Retro 📻",
    "body": "Classic hits for nostalgic evening vibes.",
  },
  {
    "title": "World Music Night 🌍",
    "body": "Global sounds to transport you this evening.",
  },
  {
    "title": "R&B Evening 🎤",
    "body": "Smooth R&B for a romantic evening atmosphere.",
  },
  {
    "title": "Country Night 🌙",
    "body": "Heartfelt country tunes for a quiet evening.",
  },
  {
    "title": "Hip-Hop Night 🎧",
    "body": "Chill hip-hop beats for evening relaxation.",
  },
  {
    "title": "Electronic Evening ⚡",
    "body": "Atmospheric electronic music for nightfall.",
  },
  {
    "title": "Evening Rock 🤘",
    "body": "Powerful rock anthems for your night energy.",
  },
  {
    "title": "Piano Night 🎹",
    "body": "Beautiful piano music for reflective evenings.",
  },
  {
    "title": "Reggae Night 🌴",
    "body": "Island vibes to keep your evening relaxed.",
  },
  {
    "title": "K-Pop Night 🌟",
    "body": "Energetic K-pop to brighten your evening.",
  },
  {
    "title": "Latin Night 💃",
    "body": "Rhythmic Latin tunes to spice up your evening.",
  },
  {
    "title": "Soul Night 🎤",
    "body": "Heartfelt soul music for deep evening moments.",
  },
  {
    "title": "Metal Night ⚡",
    "body": "Powerful metal for intense evening listening.",
  },
  {
    "title": "Blues Night 🎷",
    "body": "Soulful blues for contemplative evenings.",
  },
  {
    "title": "Opera Night 🎭",
    "body": "Dramatic opera to make your evening majestic.",
  },
  {
    "title": "Ambient Evening 🌫️",
    "body": "Atmospheric sounds for evening relaxation.",
  },
  {
    "title": "Funk Night 🕺",
    "body": "Groovy funk to get your evening dancing started.",
  },
  {
    "title": "Disco Night 🌟",
    "body": "Sparkling disco tunes to make your evening fabulous.",
  },
  {
    "title": "Bluegrass Night 🌄",
    "body": "Foot-stomping bluegrass for an energetic evening.",
  },
  {
    "title": "Evening Worship 🙏",
    "body": "Inspirational gospel for evening reflection.",
  },
  {
    "title": "Bedtime Beats 🛌",
    "body": "Calming music to help you drift off to sleep.",
  },
  {
    "title": "Evening Meditation 🧘",
    "body": "Peaceful tunes for your nighttime meditation.",
  },
  {
    "title": "Night Running 🏃",
    "body": "Energetic music for your evening workout.",
  },
  {
    "title": "Study Night 📚",
    "body": "Focus-enhancing music for evening learning sessions.",
  },
  {
    "title": "Creative Night 🎨",
    "body": "Inspirational music for nighttime creativity.",
  },
  {
    "title": "Date Night 💑",
    "body": "Romantic tunes for your evening with someone special.",
  },
  {
    "title": "Party Starter 🎉",
    "body": "Upbeat tracks to begin your night out.",
  },
  {
    "title": "Chill Vibes Only 🍃",
    "body": "Laid-back tunes for a nothing-but-relaxation evening.",
  },
  {"title": "Rainy Evening ☔", "body": "Cozy music for a quiet night indoors."},
  {
    "title": "Fireplace Songs 🔥",
    "body": "Warm tunes for a cozy evening by the fire.",
  },
  {
    "title": "Stargazing Symphony 🌠",
    "body": "Celestial music for nighttime sky watching.",
  },

  // Night notifications (40)
  {
    "title": "Late Night Vibes 🌙",
    "body": "Perfect tunes for your nighttime activities.",
  },
  {
    "title": "Midnight Melodies 🌌",
    "body": "Atmospheric music for the witching hour.",
  },
  {
    "title": "Night Owl's Playlist 🦉",
    "body": "For those who thrive when the moon is out.",
  },
  {
    "title": "Deep Night Focus 🔍",
    "body": "Concentration music for late-night work sessions.",
  },
  {
    "title": "Night Driving 🚗",
    "body": "Atmospheric tunes for midnight journeys.",
  },
  {
    "title": "Insomniac's Companion 😴",
    "body": "Calming music to help you find sleep.",
  },
  {
    "title": "Nighttime Creativity 🌃",
    "body": "Inspirational music for creative late-night sessions.",
  },
  {
    "title": "After Hours Club 🎉",
    "body": "Keep the party going with these late-night bangers.",
  },
  {
    "title": "Night Jazz 🎷",
    "body": "Smooth jazz for sophisticated nighttime vibes.",
  },
  {
    "title": "Indie Midnight 🌙",
    "body": "Moody indie artists for deep night listening.",
  },
  {
    "title": "Retro Night 📻",
    "body": "Classic hits for nostalgic late-night vibes.",
  },
  {
    "title": "World Music Night 🌍",
    "body": "Global sounds to transport you through the night.",
  },
  {
    "title": "R&B Night 🎤",
    "body": "Smooth R&B for romantic nighttime atmosphere.",
  },
  {
    "title": "Country Night 🌙",
    "body": "Heartfelt country tunes for quiet nighttime moments.",
  },
  {
    "title": "Hip-Hop Night 🎧",
    "body": "Chill hip-hop beats for late-night relaxation.",
  },
  {
    "title": "Electronic Night ⚡",
    "body": "Atmospheric electronic music for the deep night.",
  },
  {
    "title": "Night Rock 🤘",
    "body": "Powerful rock anthems for your nighttime energy.",
  },
  {
    "title": "Piano Night 🎹",
    "body": "Beautiful piano music for reflective nighttime hours.",
  },
  {
    "title": "Reggae Night 🌴",
    "body": "Island vibes to keep your night relaxed.",
  },
  {
    "title": "K-Pop Night 🌟",
    "body": "Energetic K-pop to brighten your night.",
  },
  {
    "title": "Latin Night 💃",
    "body": "Rhythmic Latin tunes to spice up your night.",
  },
  {
    "title": "Soul Night 🎤",
    "body": "Heartfelt soul music for deep nighttime moments.",
  },
  {
    "title": "Metal Night ⚡",
    "body": "Powerful metal for intense nighttime listening.",
  },
  {
    "title": "Blues Night 🎷",
    "body": "Soulful blues for contemplative nighttime hours.",
  },
  {
    "title": "Opera Night 🎭",
    "body": "Dramatic opera to make your night majestic.",
  },
  {
    "title": "Ambient Night 🌫️",
    "body": "Atmospheric sounds for nighttime relaxation.",
  },
  {
    "title": "Funk Night 🕺",
    "body": "Groovy funk to get your night dancing started.",
  },
  {
    "title": "Disco Night 🌟",
    "body": "Sparkling disco tunes to make your night fabulous.",
  },
  {
    "title": "Bluegrass Night 🌄",
    "body": "Foot-stomping bluegrass for an energetic night.",
  },
  {
    "title": "Night Worship 🙏",
    "body": "Inspirational gospel for nighttime reflection.",
  },
  {
    "title": "Sleep Sounds 🛌",
    "body": "Calming music to help you drift into deep sleep.",
  },
  {
    "title": "Night Meditation 🧘",
    "body": "Peaceful tunes for your nighttime meditation.",
  },
  {
    "title": "Night Running 🏃",
    "body": "Energetic music for your late-night workout.",
  },
  {
    "title": "Study Night 📚",
    "body": "Focus-enhancing music for overnight learning sessions.",
  },
  {
    "title": "Creative Night 🎨",
    "body": "Inspirational music for nighttime creativity.",
  },
  {
    "title": "Nightcap Notes 🥃",
    "body": "Smooth tunes for your final drink of the night.",
  },
  {
    "title": "Moonlight Mix 🌕",
    "body": "Celestial music for midnight moon gazing.",
  },
  {"title": "Night Rain ☔", "body": "Cozy music for a stormy night indoors."},
  {
    "title": "Candlelit Songs 🕯️",
    "body": "Soft tunes for a romantically lit evening.",
  },
  {
    "title": "Dreamy Soundscapes 💭",
    "body": "Ethereal music to inspire nighttime dreams.",
  },

  // Midnight notifications (40)
  {
    "title": "Midnight Magic 🌌",
    "body": "Mystical tunes for the witching hour.",
  },
  {"title": "12 AM Vibes 🕛", "body": "Your soundtrack for the midnight hour."},
  {
    "title": "After Midnight 🎉",
    "body": "Keep the party going with these late-night tracks.",
  },
  {
    "title": "Moonlight Melodies 🌕",
    "body": "Songs to accompany the midnight moon.",
  },
  {
    "title": "Night Owl's Anthem 🦉",
    "body": "For those who thrive when everyone else sleeps.",
  },
  {
    "title": "Midnight Thoughts 💭",
    "body": "Contemplative music for late-night reflection.",
  },
  {
    "title": "Dream Weaver 🛌",
    "body": "Ethereal tunes to inspire your dreams.",
  },
  {
    "title": "Starry Night Playlist 🌠",
    "body": "Cosmic music for midnight stargazing.",
  },
  {
    "title": "Insomnia Cure 😴",
    "body": "Calming sounds to help you find sleep.",
  },
  {
    "title": "Midnight Writing ✍️",
    "body": "Inspirational music for late-night creativity.",
  },
  {
    "title": "Night Shift Sounds 🌃",
    "body": "Keep energized with these midnight tracks.",
  },
  {
    "title": "Midnight Jazz 🎷",
    "body": "Smooth jazz for sophisticated late-night vibes.",
  },
  {
    "title": "Indie Midnight 🌙",
    "body": "Moody indie artists for the deepest night hours.",
  },
  {
    "title": "Retro Midnight 📻",
    "body": "Classic hits for nostalgic late-night vibes.",
  },
  {
    "title": "World Midnight 🌍",
    "body": "Global sounds to transport you through the night.",
  },
  {
    "title": "R&B Midnight 🎤",
    "body": "Smooth R&B for romantic late-night atmosphere.",
  },
  {
    "title": "Country Midnight 🌙",
    "body": "Heartfelt country tunes for quiet midnight moments.",
  },
  {
    "title": "Hip-Hop Midnight 🎧",
    "body": "Chill hip-hop beats for late-night relaxation.",
  },
  {
    "title": "Electronic Midnight ⚡",
    "body": "Atmospheric electronic music for the deepest night.",
  },
  {
    "title": "Midnight Rock 🤘",
    "body": "Powerful rock anthems for your late-night energy.",
  },
  {
    "title": "Piano Midnight 🎹",
    "body": "Beautiful piano music for reflective nighttime hours.",
  },
  {
    "title": "Reggae Midnight 🌴",
    "body": "Island vibes to keep your midnight relaxed.",
  },
  {
    "title": "K-Pop Midnight 🌟",
    "body": "Energetic K-pop to brighten your night.",
  },
  {
    "title": "Latin Midnight 💃",
    "body": "Rhythmic Latin tunes to spice up your late night.",
  },
  {
    "title": "Soul Midnight 🎤",
    "body": "Heartfelt soul music for deep nighttime moments.",
  },
  {
    "title": "Metal Midnight ⚡",
    "body": "Powerful metal for intense late-night listening.",
  },
  {
    "title": "Blues Midnight 🎷",
    "body": "Soulful blues for contemplative midnight hours.",
  },
  {
    "title": "Opera Midnight 🎭",
    "body": "Dramatic opera to make your night majestic.",
  },
  {
    "title": "Ambient Midnight 🌫️",
    "body": "Atmospheric sounds for late-night relaxation.",
  },
  {
    "title": "Funk Midnight 🕺",
    "body": "Groovy funk to get your late-night dancing started.",
  },
  {
    "title": "Disco Midnight 🌟",
    "body": "Sparkling disco tunes to make your night fabulous.",
  },
  {
    "title": "Bluegrass Midnight 🌄",
    "body": "Foot-stomping bluegrass for an energetic night.",
  },
  {
    "title": "Midnight Worship 🙏",
    "body": "Inspirational gospel for nighttime reflection.",
  },
  {
    "title": "Deep Sleep Sounds 🛌",
    "body": "Calming music to help you drift into deep sleep.",
  },
  {
    "title": "Midnight Meditation 🧘",
    "body": "Peaceful tunes for your late-night meditation.",
  },
  {
    "title": "Night Run 🏃",
    "body": "Energetic music for your midnight workout.",
  },
  {
    "title": "Study Midnight 📚",
    "body": "Focus-enhancing music for overnight learning sessions.",
  },
  {
    "title": "Creative Midnight 🎨",
    "body": "Inspirational music for late-night creativity.",
  },
  {
    "title": "Witching Hour 🧙",
    "body": "Mystical tunes for the magic between night and day.",
  },
  {
    "title": "Celestial Sounds 🪐",
    "body": "Cosmic music for connecting with the universe at midnight.",
  },
];

class MusicNotificationProvider with ChangeNotifier {
  final MusicNotificationService _notificationService =
      MusicNotificationService();
  bool _notificationsEnabled = false;
  final Map<String, int> _notificationIndices = {
    'morning': 0,
    'afternoon': 40,
    'evening': 80,
    'night': 120,
    'midnight': 160,
  };

  final Map<String, TimeOfDay> _reminderTimes = {
    'morning': TimeOfDay(hour: 7, minute: 0),
    'afternoon': TimeOfDay(hour: 12, minute: 30),
    'evening': TimeOfDay(hour: 18, minute: 0),
    'night': TimeOfDay(hour: 22, minute: 0),
    'midnight': TimeOfDay(hour: 3, minute: 0),
  };

  bool get notificationsEnabled => _notificationsEnabled;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _notificationsEnabled = prefs.getBool('notifications_enabled') ?? false;
    await _notificationService.init();

    if (_notificationsEnabled) {
      for (final period in _reminderTimes.keys) {
        await _scheduleNotification(period);
      }
    }

    notifyListeners();
  }

  Future<void> _scheduleNotification(String period) async {
    final time = _reminderTimes[period]!;
    final id = _getNotificationId(period);
    final notificationIndex = _notificationIndices[period]!;
    final notification = notificationMessages[notificationIndex];

    await _notificationService.scheduleDailyNotification(
      time,
      period,
      id,
      notification['title']!,
      notification['body']!,
    );

    // Update index for next time (cycle through the 40 notifications for each period)
    _notificationIndices[period] =
        (notificationIndex + 1) % 40 + _getPeriodBaseIndex(period);
  }

  int _getPeriodBaseIndex(String period) {
    switch (period) {
      case 'morning':
        return 0;
      case 'afternoon':
        return 40;
      case 'evening':
        return 80;
      case 'night':
        return 120;
      case 'midnight':
        return 160;
      default:
        return 0;
    }
  }

  int _getNotificationId(String period) {
    switch (period) {
      case 'morning':
        return 1;
      case 'afternoon':
        return 2;
      case 'evening':
        return 3;
      case 'night':
        return 4;
      case 'midnight':
        return 5;
      default:
        return 0;
    }
  }

  Future<void> toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    if (value) {
      final hasPermission = await _checkAndRequestNotificationPermission();
      if (!hasPermission) {
        _notificationsEnabled = false;
        notifyListeners();
        return;
      }

      for (final period in _reminderTimes.keys) {
        await _scheduleNotification(period);
      }
    } else {
      await _notificationService.cancelAllNotifications();
    }

    _notificationsEnabled = value;
    await prefs.setBool('notifications_enabled', value);
    notifyListeners();
  }

  Future<bool> _checkAndRequestNotificationPermission() async {
    try {
      if (await Permission.notification.isGranted) return true;
      final status = await Permission.notification.request();
      return status.isGranted;
    } catch (e) {
      debugPrint('Permission error: $e');
      return false;
    }
  }

  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dt);
  }
}
