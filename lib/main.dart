import 'package:flutter/material.dart';
import 'package:task_guitara_group/views/video_call_view.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final String userId = 'user_${const Uuid().v4().substring(0, 6)}';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stream Video Call Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: VideoCallView(userId: userId),
    );
  }
}
