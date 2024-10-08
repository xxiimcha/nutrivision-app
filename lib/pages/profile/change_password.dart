import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sjq/navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool showCurrentPassword = false;
  bool showNewPassword = false;
  bool showConfirmPassword = false;

  bool hasUpperLowerCase = false;
  bool hasNumberOrSymbol = false;
  bool isLongEnough = false;
  bool noSpacesOrPipes = true;
  bool passwordsMatch = false;

  @override
  void initState() {
    super.initState();
    newPasswordController.addListener(_validatePassword);
    confirmPasswordController.addListener(_validatePassword);
  }

  void _validatePassword() {
    setState(() {
      final password = newPasswordController.text;
      hasUpperLowerCase = password.contains(RegExp(r'^(?=.*[a-z])(?=.*[A-Z])'));
      hasNumberOrSymbol = password.contains(RegExp(r'(?=.*\d)|(?=.*[@$!%*#?&])'));
      isLongEnough = password.length >= 8;
      noSpacesOrPipes = !password.contains(' ') && !password.contains('|');
      passwordsMatch = password == confirmPasswordController.text;
    });
  }

  bool isValidPassword(String password) {
    return hasUpperLowerCase &&
        hasNumberOrSymbol &&
        isLongEnough &&
        noSpacesOrPipes;
  }

  void saveChanges(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not found. Please log in again.'),
        ),
      );
      return;
    }

    if (currentPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields.'),
        ),
      );
      return;
    }

    if (!passwordsMatch) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New password and confirmation do not match.'),
        ),
      );
      return;
    }

    if (!isValidPassword(newPasswordController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Password must include at least 8 characters, include one uppercase letter, one number, and one special character.'),
        ),
      );
      return;
    }

    try {
      final response = await http.put(
        Uri.parse('http://localhost:5000/api/users/$userId/change-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'currentPassword': currentPasswordController.text,
          'newPassword': newPasswordController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password changed successfully!'),
          ),
        );

        Timer(const Duration(seconds: 1), () {
          AppNavigator().pop(context);
        });
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Incorrect current password.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to change password. Please try again later.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  Widget _buildPasswordChecklist() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildChecklistItem(
            'Include lower and upper characters', hasUpperLowerCase),
        _buildChecklistItem('Include at least 1 number or symbol', hasNumberOrSymbol),
        _buildChecklistItem('Be at least 8 characters long', isLongEnough),
        _buildChecklistItem('Cannot contain spaces or "|" symbol', noSpacesOrPipes),
        _buildChecklistItem('Passwords match', passwordsMatch),
      ],
    );
  }

  Widget _buildChecklistItem(String text, bool conditionMet) {
    return Row(
      children: [
        Icon(
          conditionMet ? Icons.check : Icons.close,
          color: conditionMet ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            color: conditionMet ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 120),
              const Row(
                children: [
                  Text(
                    'Change your password',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFF96B0D7)),
                child: Padding(
                  padding: const EdgeInsetsDirectional.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Current Password"),
                      TextField(
                        controller: currentPasswordController,
                        obscureText: !showCurrentPassword,
                        decoration: InputDecoration(
                          hintText: 'Input current password',
                          suffixIcon: IconButton(
                            icon: Icon(showCurrentPassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                showCurrentPassword = !showCurrentPassword;
                              });
                            },
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text("New Password"),
                      TextField(
                        controller: newPasswordController,
                        obscureText: !showNewPassword,
                        decoration: InputDecoration(
                          hintText: 'Input new password',
                          suffixIcon: IconButton(
                            icon: Icon(showNewPassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                showNewPassword = !showNewPassword;
                              });
                            },
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text("Confirm Password"),
                      TextField(
                        controller: confirmPasswordController,
                        obscureText: !showConfirmPassword,
                        decoration: InputDecoration(
                          hintText: 'Confirm new password',
                          suffixIcon: IconButton(
                            icon: Icon(showConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                showConfirmPassword = !showConfirmPassword;
                              });
                            },
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildPasswordChecklist(),
                      const SizedBox(height: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: double.infinity),
                          ElevatedButton(
                            onPressed: _canSave() ? () {
                              saveChanges(context);
                            } : null,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            child: const Padding(
                              padding: EdgeInsetsDirectional.symmetric(
                                  horizontal: 20),
                              child: Text(
                                "SAVE",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _canSave() {
    return hasUpperLowerCase &&
        hasNumberOrSymbol &&
        isLongEnough &&
        noSpacesOrPipes &&
        passwordsMatch;
  }
}
