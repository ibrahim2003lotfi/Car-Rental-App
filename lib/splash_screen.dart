import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _lottieController;
  late final AnimationController _fadeController;
  // ignore: unused_field
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
    // Controller for fade-out
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600), // fade duration
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    // Listen for when animation completes
    _lottieController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _fadeController.forward().whenComplete(() {
          Navigator.pushReplacementNamed(context, '/authstate');
        });
      }
    });
  }

  @override
  void dispose() {
    _lottieController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      body: FadeTransition(
        opacity: Tween<double>(begin: 1.0, end: 0).animate(_fadeAnimation),
        child: Center(
          child: Container(
            child: Lottie.asset(
              'assets/lotties/YcCQDLxBy5.json',
              fit: BoxFit.contain,
              controller: _lottieController,
              onLoaded: (composition) {
                _lottieController
                  ..duration = composition.duration
                  ..forward();
              },
            ),
          ),
        ),
      ),
    );
  }
}
