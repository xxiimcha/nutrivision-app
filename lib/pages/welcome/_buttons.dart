import 'package:flutter/material.dart';
import 'package:sjq/navigator.dart';
import 'package:sjq/themes/themes.dart';

// Here are the buttons for the Welcome Page
class SignupButton extends StatelessWidget {
  const SignupButton({super.key});

  @override
  Widget build(BuildContext context) {
    var padding = Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 30),
      child: Text(
        "Let's get started",
        style: paragraphM.copyWith(color: Colors.white),
      ),
    );

    return ElevatedButton(
      onPressed: () => AppNavigator().toSignupScreen(context),
      style: ElevatedButton.styleFrom(backgroundColor: colorBlue),
      child: padding,
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    var text = Text(
      "Already have an account? LOGIN",
      style: paragraphM.copyWith(color: colorBlue),
    );

    return GestureDetector(
      onTap: () => AppNavigator().toLoginScreen(context),
      child: text,
    );
  }
}
