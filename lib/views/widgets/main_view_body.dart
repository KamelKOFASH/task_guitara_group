import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:task_guitara_group/views/call_view.dart';

class MainViewBody extends StatelessWidget {
  const MainViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text('Create Call'),
        onPressed: () async {
          try {
            var call = StreamVideo.instance.makeCall(
              callType: StreamCallType.defaultType(),
              id: 'yB6ch0nTghT5',
            );

            await call.getOrCreate();

            // Created ahead
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CallView(call: call)),
            );
          } catch (e) {
            debugPrint('Error joining or creating call: $e');
            debugPrint(e.toString());
          }
        },
      ),
    );
  }
}
