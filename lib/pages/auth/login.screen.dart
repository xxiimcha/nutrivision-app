import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sjq/pages/auth/_buttons.dart';
import 'package:sjq/pages/auth/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final usernameOrEmailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'images/cembo.jpg',
                ), // Path to your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black
                  .withOpacity(0), // This ensures the blur effect is applied
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  SizedBox(
                    height: 300, // Adjust the height to your preference
                    width: 300, // Adjust the width to your preference
                    child: Image.asset(
                      'images/logo2.png', // Path to your image
                    ),
                  ),
                  const SizedBox(height: 20),
                  LoginForm(
                    formKey: formKey,
                    usernameOrEmailController: usernameOrEmailController,
                    passwordController: passwordController,
                  ),
                  const SizedBox(height: 30),
                  LoginButton(
                    formKey: formKey,
                    usernameOrEmailController: usernameOrEmailController,
                    passwordController: passwordController,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
