import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  late AudioCache _audioCache;
  late Map<String, String> _soundUrls;

  factory SoundManager() => _instance;

  SoundManager._internal() {
    _audioCache = AudioCache();
    _soundUrls = {
      'Bruh': 'sounds/bruh.mp3',
      'FBI': 'sounds/fbi-open-up.mp3',
      'VineBoom': 'sounds/vine-boom.mp3',
    };
  }

  void initialize() {
    _audioCache.loadAll(_soundUrls.values.toList());
  }

  void playSoundOnce(String soundName) {
    if (_soundUrls.containsKey(soundName)) {
      _audioCache.play(_soundUrls[soundName]!, volume: 0.5);
    }
  }
}
