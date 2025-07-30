import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../manager/cubit/video_call_cubit.dart';

class VideoCallViewBody extends StatelessWidget {
  const VideoCallViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Group Video Call')),
      body: BlocBuilder<VideoCallCubit, VideoCallState>(
        builder: (context, state) {
          if (state is VideoCallLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VideoCallJoined) {
            return Column(
              children: [
                Expanded(
                  child: StreamCallContainer(
                    call: state.call,
                    child: const CallContentLayout(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.call_end),
                    label: const Text("End Call"),
                    onPressed: () {
                      context.read<VideoCallCubit>().leaveCall();
                    },
                  ),
                )
              ],
            );
          } else if (state is VideoCallError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is VideoCallLeft) {
            return const Center(child: Text('You left the call.'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
