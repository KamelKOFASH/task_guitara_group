import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:task_guitara_group/views/video_call_view.dart';
import 'package:task_guitara_group/core/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _callIdController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();

    //? Generate default call ID
    _callIdController.text = 'call-${const Uuid().v4().substring(0, 8)}';
  }

  @override
  void dispose() {
    _animationController.dispose();
    _userNameController.dispose();
    _callIdController.dispose();
    super.dispose();
  }

  void _joinCall() {
    if (_userNameController.text.trim().isEmpty) {
      _showSnackBar('Please enter your name', Colors.orange);
      return;
    }

    if (_callIdController.text.trim().isEmpty) {
      _showSnackBar('Please enter a call ID', Colors.orange);
      return;
    }

    final userId = 'user_${const Uuid().v4().substring(0, 6)}';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoCallView(
          userId: userId,
          userName: _userNameController.text.trim(),
          callId: _callIdController.text.trim(),
        ),
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.gradientDecoration,
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),

                    // App Title
                    Text(
                      'Stream Video Call',
                      style: AppTheme.headingStyle,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Connect with anyone, anywhere',
                      style: AppTheme.subheadingStyle,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 60),

                    // Input Card
                    Card(
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Join a Call',
                              style: AppTheme.cardTitleStyle,
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 24),

                            // User Name Input
                            TextField(
                              controller: _userNameController,
                              decoration: InputDecoration(
                                labelText: 'Your Name',
                                hintText: 'Enter your display name',
                                prefixIcon: const Icon(Icons.person_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF667eea),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Call ID Input
                            TextField(
                              controller: _callIdController,
                              decoration: InputDecoration(
                                labelText: 'Call ID',
                                hintText: 'Enter call ID or use generated one',
                                prefixIcon: const Icon(
                                  Icons.video_call_outlined,
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.refresh),
                                  onPressed: () {
                                    _callIdController.text =
                                        'call-${const Uuid().v4().substring(0, 8)}';
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF667eea),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Join Call Button
                            ElevatedButton(
                              onPressed: _joinCall,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF667eea),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 8,
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.video_call, size: 24),
                                  SizedBox(width: 8),
                                  Text(
                                    'Join Call',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Footer
                    const Text(
                      'Powered by Stream.io',
                      style: TextStyle(color: Colors.white60, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
