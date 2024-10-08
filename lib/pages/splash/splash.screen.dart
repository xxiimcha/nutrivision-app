import 'package:flutter/material.dart';
import 'package:sjq/services/services.dart';

// This is Splash Screen. It will only show up for almost 2 seconds.
// This is responsible for logging the user in.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthService service = AuthService();
  @override
  void initState() {
    super.initState();
    service.login(context);
  }

  @override
  Widget build(BuildContext context) {
    // Get Screen Dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate image width and height based on screen size
    final imageWidth = screenWidth * 0.9; // Adjust as needed
    final imageHeight = screenHeight * 0.5; // Adjust as needed

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: imageWidth,
                  height: imageHeight,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
