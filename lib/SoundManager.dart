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
      'Ayo': 'sounds/ayo-wtf.mp3',
      'Rizz': 'sounds/rizz.mp3',
      'Amongus': 'sounds/amongus.mp3',
      'Achievement': 'sounds/city-folk-achievement.mp3',
      'Amazed': 'sounds/ac-amazed.mp3',
      'Shocked': 'sounds/ac-shocked.mp3',
      'MainTheme': 'sounds/Main_Theme_PG.mp3',
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

  void playSoundOnceVolumeAdjust(String soundName, double volumeAmount) {
    if (_soundUrls.containsKey(soundName)) {
      _audioCache.play(_soundUrls[soundName]!, volume: volumeAmount);
    }
  }
}
