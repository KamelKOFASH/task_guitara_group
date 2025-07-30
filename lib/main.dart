import 'package:flutter/material.dart';
import 'package:task_guitara_group/views/video_call_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: VideoCallView(),
    );
  }
}