import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkUserAuthentication();
  }

  void checkUserAuthentication() async {
    // Add a delay to show splash screen
    await Future.delayed(const Duration(seconds: 2));
    
    try {
      // Check if onboarding was completed
      final prefs = await SharedPreferences.getInstance();
      final bool onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
      
      if (!mounted) return;
      
      // Get the auth provider
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      if (authProvider.isAuthenticated) {
        // User is logged in - navigate to home screen
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        // User is not logged in
        if (onboardingCompleted) {
          // Onboarding is completed, navigate to login
          Navigator.of(context).pushReplacementNamed('/login');
        } else {
          // Onboarding not completed, navigate to onboarding
          Navigator.of(context).pushReplacementNamed('/onboarding');
        }
      }
    } catch (e) {
      debugPrint('Error during auth check: $e');
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Base gradient layer
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF6A11CB), // Deep purple
                  Color(0xFF2575FC), // Light blue
                ],
              ),
            ),
          ),
          // White radial gradient overlay at bottom right
          Positioned(
            right: -50,
            bottom: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.9),
                    Colors.white.withOpacity(0.0),
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
          ),
          // Content layer
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                // Top indicator text
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Text(
                    'splashscreen',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                ),
                // Expanded space
                const Expanded(child: SizedBox()),
                // Logo in the center
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Icon(
                      Icons.waves,
                      color: const Color(0xFF6A11CB),
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // App name
                const Text(
                  'CIPHERX',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                // Expanded space
                const Expanded(child: SizedBox()),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 