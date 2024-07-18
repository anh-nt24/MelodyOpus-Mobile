import 'package:just_audio/just_audio.dart';
import 'package:melodyopus/models/song.dart';
import 'package:rxdart/rxdart.dart';

import 'duration_state.dart';


class AudioManager {

  AudioManager();

  final _player = AudioPlayer();
  Stream<DurationState>? durationState;

  get getPlayerStateStream => _player.playerStateStream;
  
  void init() {
    durationState = Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
      _player.positionStream,
      _player.playbackEventStream,
        (position, playbackSate) => DurationState(
          progress: position,
          buffer: playbackSate.bufferedPosition,
          total: playbackSate.duration
        ),
    );
  }

  void dispose() {
    _player.dispose();
  }

  void setLoopMode(LoopMode loopMode) {
    _player.setLoopMode(loopMode);
  }

  void play() {
    _player.play();
  }

  void seekTo(Duration position) {
    _player.seek(position);
  }

  void pause() {
    _player.pause();
  }

  void replay() {
    _player.seek(Duration.zero);
  }

  Future<void> setUrl(String url) async {
    await _player.setUrl(url);
  }
}