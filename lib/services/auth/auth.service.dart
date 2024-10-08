import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sjq/navigator.dart';

class AuthService {
  // This function will be called at startup.
  Future<void> login(BuildContext context) async {
    // Login user here.
    // using 'Firebase'
    // FirebaseAuth auth = FirebaseAuth.instance;
    // final user = auth.currentUser;
    // if (user != null){
    // If user logged in, go to dashboard
    // }else {
    // It no user found, go to login
    // }

    // There is no backend yet, for the mean time. use timer
    Timer(const Duration(seconds: 4), () {
      // Navigate to Welcome page
      AppNavigator().toWelcomeScreen(context);
    });
  }
}
