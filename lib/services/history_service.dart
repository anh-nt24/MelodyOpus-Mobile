import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:melodyopus/repositories/history_repository.dart';

class HistoryService {
  final HistoryRepository _repository = HistoryRepository();

  Timer? _positionTimer;

  final AudioPlayer _audioPlayer;

  HistoryService(this._audioPlayer);


  void startListening(int songId) async {
    await _repository.addHistory(songId);

    _startPositionTimer(songId);
  }

  void stopListening(int songId) async {
    await _repository.stopListening(songId);

    _positionTimer?.cancel();
  }

  Future<List<Map<String, dynamic>>> getSongsInHistory() async {
    return await _repository.getAllSongsInHistory();
  }

  void _startPositionTimer(int songId) {
    _positionTimer?.cancel();

    _positionTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (_audioPlayer.playing) {
        final position = _audioPlayer.position.inSeconds;
        await _repository.updatePosition(songId, position);
      }
    });
  }
}