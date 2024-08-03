import 'dart:async';

import 'package:melodyopus/repositories/like_repository.dart';

class LikeService {
  LikeService._internal();

  static final LikeService _instance = LikeService._internal();

  factory LikeService() => _instance;

  final LikeRepository _likeRepository = LikeRepository();

  Future<bool> checkLike(int songId, String jwt) async {
    try {
      return await _likeRepository.checkLike(songId, jwt);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addLike(int songId, String jwt) async {
    try {
      await _likeRepository.addLike(songId, jwt);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> unLike(int songId, String jwt) async {
    try {
      await _likeRepository.unLike(songId, jwt);
    } catch (e) {
      rethrow;
    }
  }
}