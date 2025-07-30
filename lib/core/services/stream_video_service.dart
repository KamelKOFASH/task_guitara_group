import 'dart:developer';

import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:task_guitara_group/core/constants.dart';
import 'package:task_guitara_group/core/token_generator.dart';

class StreamVideoService {
  static StreamVideo? _instance;
  static String? _currentUserId;

  /// Get or create StreamVideo instance
  static Future<StreamVideo> getInstance({
    required String userId,
    required String userName,
  }) async {
    log('StreamVideoService: Getting instance for user $userId');

    // Always reset the StreamVideo SDK first to avoid conflicts
    try {
      await StreamVideo.reset();
      log('StreamVideoService: Successfully reset StreamVideo SDK');
    } catch (e) {
      log('StreamVideoService: Error resetting StreamVideo SDK: $e');
    }

    // Clear our internal instance tracking
    _instance = null;
    _currentUserId = null;

    // Create new instance
    log('StreamVideoService: Creating new instance for user $userId');
    final user = User.regular(userId: userId, name: userName);

    final token = TokenGenerator.generateDevelopmentToken(
      apiSecret: apiSecret,
      userId: userId,
    );

    _instance = StreamVideo(apiKey, user: user, userToken: token);
    _currentUserId = userId;

    log('StreamVideoService: Successfully created new instance');
    return _instance!;
  }

  /// Reset the StreamVideo instance
  static Future<void> reset() async {
    log('StreamVideoService: Resetting StreamVideo service');

    // Use the official StreamVideo.reset() method
    try {
      await StreamVideo.reset();
      log('StreamVideoService: Successfully reset StreamVideo SDK');
    } catch (e) {
      log('StreamVideoService: Error resetting StreamVideo SDK: $e');
    }

    // Clear our internal tracking
    _instance = null;
    _currentUserId = null;

    log('StreamVideoService: Reset complete');
  }

  /// Check if instance exists
  static bool get hasInstance => _instance != null;

  /// Get current user ID
  static String? get currentUserId => _currentUserId;
}
