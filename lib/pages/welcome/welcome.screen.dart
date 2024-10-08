import 'package:flutter/material.dart';
import 'package:sjq/themes/themes.dart';

import '_buttons.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: double.infinity),
                  Text(
                    "Welcome to\nNutrivision",
                    style: headingL.copyWith(
                      color: colorBlue,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "eat right, be bright",
                    style: headingM.copyWith(
                      color: colorLightBlue,
                    ),
                  )
                ],
              ),
            ),
            const Column(
              children: [
                SignupButton(),
                SizedBox(height: 10),
                Text(
                  "OR",
                  style: paragraphM,
                ),
                SizedBox(height: 10),
                LoginButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
