import 'package:flutter/material.dart';
import 'package:sjq/navigator.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Logout User here
        AppNavigator().toStartUpScreen(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
      ),
      child: const Padding(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 20,
        ),
        child: Text(
          "Logout",
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }
}

class AboutButton extends StatelessWidget {
  const AboutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        AppNavigator().toAboutScreen(context);
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      child: const Text(
        "ABOUT US",
        style: TextStyle(
          color: Colors.black87,
          decoration: TextDecoration.underline,
          decorationThickness: 1.5,
        ),
      ),
    );
  }
}
