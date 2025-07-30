import 'package:flutter/material.dart';
import 'package:task_guitara_group/views/home_screen.dart';
import 'package:task_guitara_group/core/app_theme.dart';
import 'package:task_guitara_group/core/services/stream_video_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Reset StreamVideo when app is terminated or detached
    if (state == AppLifecycleState.detached) {
      StreamVideoService.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stream Video Call Demo',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
