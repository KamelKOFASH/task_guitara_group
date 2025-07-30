import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:task_guitara_group/core/constants.dart';
import 'package:task_guitara_group/core/token_generator.dart';

class VideoCallView extends StatefulWidget {
  final String userId;
  const VideoCallView({super.key, required this.userId});

  @override
  State<VideoCallView> createState() => _VideoCallViewState();
}

class _VideoCallViewState extends State<VideoCallView> {
  late StreamVideo streamVideo;
  late Call call;

  @override
  void initState() {
    super.initState();

    // Initialize StreamVideo with your API key and user token
    final user = User.regular(userId: widget.userId);

    // Generate development token (WARNING: Only for development!)
    final token = TokenGenerator.generateDevelopmentToken(
      apiSecret: apiSecret,
      userId: widget.userId,
    );

    streamVideo = StreamVideo(apiKey, user: user, userToken: token);

    // Join predefined room
    call = streamVideo.makeCall(
      callType: StreamCallType.defaultType(),
      id: 'yB6ch0nTghT5',
    );

    _joinCall();
  }

  Future<void> _joinCall() async {
    await call.join();
  }

  void _leaveCall() async {
    await call.leave();
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    call.leave();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Room - ${widget.userId}'),
        actions: [
          IconButton(icon: Icon(Icons.call_end), onPressed: _leaveCall),
        ],
      ),
      body: StreamCallContainer(
        call: call,
        callContentBuilder:
            (BuildContext context, Call call, CallState callState) {
              return StreamCallContent(
                call: call,
                callState: callState,
                callControlsBuilder:
                    (BuildContext context, Call call, CallState callState) {
                      final localParticipant = callState.localParticipant!;
                      return StreamCallControls(
                        options: [
                          CallControlOption(
                            icon: const Icon(Icons.chat_outlined),
                            onPressed: () {
                              // Open your chat window
                            },
                          ),
                          FlipCameraOption(
                            call: call,
                            localParticipant: localParticipant,
                          ),
                          AddReactionOption(
                            call: call,
                            localParticipant: localParticipant,
                          ),
                          ToggleMicrophoneOption(
                            call: call,
                            localParticipant: localParticipant,
                          ),
                          ToggleCameraOption(
                            call: call,
                            localParticipant: localParticipant,
                          ),
                          LeaveCallOption(
                            call: call,
                            onLeaveCallTap: () {
                              call.leave();
                            },
                          ),
                        ],
                      );
                    },
              );
            },
      ),
    );
  }
}
