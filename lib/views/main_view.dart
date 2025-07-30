import 'package:flutter/material.dart';
import 'package:task_guitara_group/views/widgets/main_view_body.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Video Call'),
      ),
      body: MainViewBody(),
    );
  }
}
