import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  final Widget child;
  final bool showSplash;
  
  const SplashScreen({
    super.key,
    required this.child,
    this.showSplash = true,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    if (widget.showSplash) {
      // Show splash for 3 seconds, then navigate to the child widget
      Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showSplash = false;
          });
        }
      });
    } else {
      _showSplash = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showSplash || !_showSplash) {
      return widget.child;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Splash GIF
            Image.asset(
              'splash.gif',
              width: 300,
              height: 300,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
