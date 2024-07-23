import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:melodyopus/audio_helpers/audio_manager.dart';
import 'package:melodyopus/audio_helpers/duration_state.dart';
import 'package:melodyopus/models/song.dart';


class MusicPlayerProvider with ChangeNotifier {
  MusicPlayerProvider._internal();
  static final MusicPlayerProvider _instance = MusicPlayerProvider._internal();
  factory MusicPlayerProvider() {
    return _instance;
  }


  final AudioManager _audioManager = AudioManager();
  List<Song> _playlist = [];
  int _currentIndex = 0;

  bool _isFullScreen = true;

  bool _playing = false;

  List<Song> get playlist => _playlist;
  int get currentIndex => _currentIndex;
  Stream<DurationState>? get durationState => _audioManager.durationState;
  bool get isPlaying => _playing;
  bool get isFullScreen => _isFullScreen;

  Song? _oldSong = null;

  Song? get currentSong => _playlist.isNotEmpty ? _playlist[_currentIndex] : null;
  Song? get oldSong => _oldSong;

  get getPlayerStateStream => _audioManager.getPlayerStateStream;

  void setFullScreen(bool isShown) {
    _isFullScreen = isShown;
    notifyListeners();
  }


  void setPlaylist(List<Song> songs, {int index = 0}) {
    if (_playlist.isNotEmpty
        && songs.isNotEmpty
        && songs[index].filePath == currentSong?.filePath) {
      _audioManager.init();
      _audioManager.play();
    } else {
      _playlist = songs;
      _currentIndex = index;
      _playCurrentSong();
    }
  }

  void playAtIndex(int index) {
    _oldSong = currentSong;
    _currentIndex = index;
    _playCurrentSong();
  }

  void playNext() {
    _oldSong = currentSong;
    if (_playlist.length == 1) {
      _audioManager.replay();
    } else if (_currentIndex < _playlist.length - 1) {
      _currentIndex++;
      _playCurrentSong();
    } else {
      _currentIndex = 0;
      _playCurrentSong();
    }
  }

  void playPrevious() {
    _oldSong = currentSong;
    if (_playlist.length == 1) {
      _audioManager.replay();
    } else if (_currentIndex > 0) {
      _currentIndex--;
      _playCurrentSong();
    } else {
      _currentIndex = _playlist.length - 1;
      _playCurrentSong();
    }
  }

  void _playCurrentSong() {
    if (currentSong != null) {
      _audioManager.setUrl(currentSong!.filePath);
      _audioManager.init();
      _audioManager.play();
      _playing = true;
      notifyListeners();
    }
  }

  void play() {
    _audioManager.play();
    _playing = true;
    notifyListeners();
  }

  void pause() {
    _audioManager.pause();
    _playing = false;
    notifyListeners();
  }

  void stop() async {
    _audioManager.pause();
    _playing = false;
    notifyListeners();
  }


  void dispose() {
    _audioManager.dispose();
    _playing = false;
    super.dispose();
  }

  void setLoopMode(LoopMode loopMode) {
    _audioManager.setLoopMode(loopMode);
    notifyListeners();
  }

  void seekTo(Duration position) {
    _audioManager.seekTo(position);
  }
}