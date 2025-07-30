import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/cubit/video_call_cubit.dart';
import 'widgets/video_call_view_body.dart';

class VideoCallView extends StatelessWidget {
  const VideoCallView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VideoCallCubit(apiKey: 'YOUR_API_KEY'),
      child: VideoCallViewBody(),
    );
  }
}

