import 'package:flutter/material.dart';
import 'http_service.dart'; // Import the HTTP service
import 'account_verify.dart'; // Import the VerifyEmailPage

class SignupForm extends StatelessWidget {
  const SignupForm({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InputText(
            controller: usernameController,
            icon: Icons.person,
            label: 'Username',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username';
              } else if (value.length < 5) {
                return 'Username must be at least 5 characters';
              } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                return 'Username can only contain letters and numbers';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          InputText(
            controller: emailController,
            icon: Icons.email,
            label: 'Email',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid email address';
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
                return 'Please enter your password';
              } else if (value.length < 8) {
                return 'Password must be at least 8 characters';
              } else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]+$').hasMatch(value)) {
                return 'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          PasswordInputText(
            controller: confirmPasswordController,
            label: "Confirm Password",
            icon: Icons.lock,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          // The SignupButton will be included outside this form widget
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
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        labelText: label,
        labelStyle: Theme.of(context).textTheme.bodyMedium,
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
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        labelText: widget.label,
        labelStyle: Theme.of(context).textTheme.bodyMedium,
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
