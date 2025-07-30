import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:uuid/uuid.dart';

part 'video_call_state.dart';

class VideoCallCubit extends Cubit<VideoCallState> {
  final String apiKey;
  late StreamVideo _streamVideo;
  late Call _call;
  late String _userId;

  VideoCallCubit({required this.apiKey}) : super(VideoCallInitial()) {
    _init();
  }

  void _init() async {
    emit(VideoCallLoading());
    try {
      _userId = 'user_${const Uuid().v4().substring(0, 6)}';

      _streamVideo = StreamVideo(
        apiKey,
        user: User.regular(userId: _userId, name: 'User $_userId'),
      );

      _call = _streamVideo.makeCall(type: 'default', id: 'test-room');
      await _call.join();

      emit(VideoCallJoined(call: _call, userId: _userId));
    } catch (e) {
      emit(VideoCallError(message: e.toString()));
    }
  }

  void leaveCall() async {
    await _call.leave();
    emit(VideoCallLeft());
  }
}
