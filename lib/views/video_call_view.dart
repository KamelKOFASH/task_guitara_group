import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:task_guitara_group/views/widgets/loading_screen.dart';
import 'package:task_guitara_group/core/services/stream_video_service.dart';

class VideoCallView extends StatefulWidget {
  final String userId;
  final String userName;
  final String callId;

  const VideoCallView({
    super.key,
    required this.userId,
    required this.userName,
    required this.callId,
  });

  @override
  State<VideoCallView> createState() => _VideoCallViewState();
}

class _VideoCallViewState extends State<VideoCallView> {
  late StreamVideo streamVideo;
  late Call call;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeStreamVideo();
  }

  Future<void> _initializeStreamVideo() async {
    try {
      // Get StreamVideo instance using the service
      streamVideo = await StreamVideoService.getInstance(
        userId: widget.userId,
        userName: widget.userName,
      );

      // Join the specified call for every call Id
      call = streamVideo.makeCall(
        callType: StreamCallType.defaultType(),
        id: widget.callId,
      );

      await _joinCall();
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to initialize video call: $e';
        });
      }
    }
  }

  Future<void> _joinCall() async {
    try {
      await call.join();
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to join call: $e';
        });
      }
    }
  }

  void _leaveCall() async {
    await call.leave();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    call.leave();
    // Don't disconnect StreamVideo here as it might be used by other screens
    StreamVideoService.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show loading screen while connecting
    if (isLoading) {
      return LoadingScreen(message: 'Connecting to ${widget.callId}...');
    }

    // Show error screen if connection failed
    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Connection Error'),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  errorMessage!,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.userName} - ${widget.callId}'),
        backgroundColor: const Color(0xFF667eea),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: StreamCallContainer(
        call: call,
        callContentWidgetBuilder: (BuildContext context, Call call) {
          return StreamCallContent(
            call: call,
            callControlsWidgetBuilder: (BuildContext context, Call call) {
              return StreamCallControls(
                options: [
                  CallControlOption(
                    icon: const Icon(Icons.chat_outlined, color: Colors.white),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Chat feature coming soon!'),
                          backgroundColor: Color(0xFF667eea),
                        ),
                      );
                    },
                  ),
                  FlipCameraOption(call: call),
                  AddReactionOption(call: call),
                  ToggleMicrophoneOption(call: call),
                  ToggleCameraOption(call: call),
                  LeaveCallOption(call: call, onLeaveCallTap: _leaveCall),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
