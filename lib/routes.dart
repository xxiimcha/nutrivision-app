import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sjq/pages/pages.dart';
// This is Routes.
// All the pages available will be found here

abstract class Routes {
  static const start = '/';
  static const welcomeScreen = '/welcome';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const profile = '/profile';
  static const editProfile = '/edit-profile';
  static const about = '/about';
  static const changePassword = '/change-password';
  static const notification = '/notification';
  static const updateNutritionalStatus = '/update-nutritional-status';

  static Map<String, WidgetBuilder> routes = {
    start: (_) => const SplashScreen(),
    welcomeScreen: (_) => const WelcomeScreen(),
    login: (_) => const LoginPage(),
    signup: (_) => const SignUpPage(),
    home: (_) => const HomeScreen(),
    profile: (_) => const ProfileScreen(),
    editProfile: (_) => const EditProfileScreen(),
    about: (_) => const AboutUsScreen(),
    changePassword: (_) => const ChangePassword(),
    updateNutritionalStatus: (_) => const UpdateStatusScreen(),
    notification: (_) => const NotificationScreen()
  };
}
