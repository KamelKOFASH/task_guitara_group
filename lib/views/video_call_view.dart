import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:task_guitara_group/views/widgets/custom_error_view.dart';
import 'package:task_guitara_group/views/widgets/custom_loading_view.dart';
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
        callType:
            StreamCallType.defaultType(), // more types available like  StreamCallType.audio(), StreamCallType.video(), StreamCallType.screenShare()
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
      return CustomLoadingView(message: 'Connecting to ${widget.callId}...');
    }

    // Show error screen if connection failed
    if (errorMessage != null) {
      return CustomErrorView(errorMessage: errorMessage);
    }
    // Show video call screen if connected
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.userName} - ${widget.callId}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xfff6f7f9),
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
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
