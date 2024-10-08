// Using singleton approach, we can ensure that our appnavigator wont be reinitialized.

// This is AppNavigator.
// This class handles all the navigation part in our app.
import 'package:flutter/material.dart';
import 'package:sjq/routes.dart';

class AppNavigator {
  factory AppNavigator() {
    return _instance;
  }

  AppNavigator._();
  static final AppNavigator _instance = AppNavigator._();

  // Go back
  void pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  void toAboutScreen(BuildContext context) {
    Navigator.of(context).pushNamed(Routes.about);
  }

  void toNotificationScreen(BuildContext context) {
    Navigator.of(context).pushNamed(Routes.notification);
  }

  void toEditProfileScreen(BuildContext context) {
    Navigator.of(context).pushNamed(Routes.editProfile);
  }

  void toChangePassword(BuildContext context) {
    Navigator.of(context).pushNamed(Routes.changePassword);
  }

  void toUpdateNutritionStats(BuildContext context) {
    Navigator.of(context).pushNamed(Routes.updateNutritionalStatus);
  }

  void toSignupScreen(BuildContext context) {
    Navigator.of(context).popAndPushNamed(Routes.signup);
  }

  void toLoginScreen(BuildContext context) {
    Navigator.of(context).popAndPushNamed(Routes.login);
  }

  void toHome(BuildContext context) {
    Navigator.of(context).popAndPushNamed(Routes.home);
  }

  // To Welcome Screen
  void toWelcomeScreen(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(Routes.welcomeScreen);
  }

  void toStartUpScreen(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(Routes.start);
  }

  // Go to
  void to(BuildContext context, Widget to) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => to));
  }
}
