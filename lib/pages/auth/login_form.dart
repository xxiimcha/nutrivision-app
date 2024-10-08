import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../home/home.screen.dart'; // Import the HomeScreen
import 'package:sjq/pages/auth/forgot_password_page.dart'; // Import the ForgotPasswordPage

// Assuming these are defined somewhere in your themes file
import 'package:sjq/themes/themes.dart';

// Assuming this is a separate widget in your project
import 'package:sjq/pages/auth/_buttons.dart'; 

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> _formKey;
  final TextEditingController usernameOrEmailController;
  final TextEditingController passwordController;

  LoginForm({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.usernameOrEmailController,
    required this.passwordController,
  }) : _formKey = formKey;

  Future<void> _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Create a map with the login details
      Map<String, String> loginDetails = {
        'identifier': usernameOrEmailController.text,
        'password': passwordController.text,
      };

      try {
        // Send login request to the server
        final response = await http.post(
          Uri.parse('http://localhost:5000/api/auth/login'), // Adjust the URL as needed
          headers: {'Content-Type': 'application/json'},
          body: json.encode(loginDetails),
        );

        if (response.statusCode == 200) {
          // On success, navigate to the HomeScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          // On failure, display an error message
          final errorResponse = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorResponse['msg'] ?? 'Invalid credentials')),
          );
        }
      } catch (error) {
        // Handle any errors that occur during the request
        print('Login request error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
    } else {
      print('Form validation failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InputText(
            controller: usernameOrEmailController,
            label: "Username or Email",
            icon: Icons.person,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter username or email';
              } else if (value.length < 5) {
                return 'Username or Email must be at least 5 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          PasswordInputText(
            controller: passwordController,
            label: "Password",
            icon: Icons.lock,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgotPasswordPage(),
                    ),
                  );
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Input Text Class
class InputText extends StatelessWidget {
  const InputText({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.validator,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: paragraphM.copyWith(color: Colors.black),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        labelText: label,
        labelStyle: paragraphM,
        prefixIcon: Icon(icon),
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
      validator: validator,
    );
  }
}

// Password Input Text Class with Toggle Visibility
class PasswordInputText extends StatefulWidget {
  const PasswordInputText({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.validator,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;

  @override
  _PasswordInputTextState createState() => _PasswordInputTextState();
}

class _PasswordInputTextState extends State<PasswordInputText> {
  bool _isHidden = true;

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _isHidden,
      style: paragraphM.copyWith(color: Colors.black),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        labelText: widget.label,
        labelStyle: paragraphM,
        prefixIcon: Icon(widget.icon),
        suffixIcon: IconButton(
          icon: Icon(
            _isHidden ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: _toggleVisibility,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
      validator: widget.validator,
    );
  }
}
