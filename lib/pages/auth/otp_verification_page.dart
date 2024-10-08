import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'reset_password_page.dart';

class OtpVerificationPage extends StatelessWidget {
  final String email;
  const OtpVerificationPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    // Separate controllers for each OTP box
    final otpController1 = TextEditingController();
    final otpController2 = TextEditingController();
    final otpController3 = TextEditingController();
    final otpController4 = TextEditingController();

    Future<void> _verifyOtp(BuildContext context) async {
      if (formKey.currentState!.validate()) {
        final otp = otpController1.text +
            otpController2.text +
            otpController3.text +
            otpController4.text;

        try {
          // Make HTTP request to verify OTP
          final response = await http.post(
            Uri.parse('http://localhost:5000/api/auth/verify-otp'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'email': email, 'otp': otp}),
          );

          if (response.statusCode == 200) {
            // Navigate to reset password page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResetPasswordPage(email: email),
              ),
            );
          } else {
            // Handle server errors
            final errorResponse = json.decode(response.body);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorResponse['message'] ?? 'Invalid OTP')),
            );
          }
        } catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('An error occurred. Please try again.')),
          );
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,  // Background color to white for clean look
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Verify your email",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A73E8),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "A verification email has been sent to your email address. Please check your email to verify the change.",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF616161),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Please enter 4 digit code sent to:",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF616161),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              email,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Form(
              key: formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _otpBox(context, otpController1),
                  _otpBox(context, otpController2),
                  _otpBox(context, otpController3),
                  _otpBox(context, otpController4),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: TextButton(
                onPressed: () {
                  // Handle resend OTP logic
                },
                child: const Text(
                  "RESEND CODE?",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1A73E8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () => _verifyOtp(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A73E8),
                  padding: const EdgeInsets.symmetric(
                      vertical: 15, horizontal: 100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "CONFIRM",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // OTP input box widget with consistent styling
  Widget _otpBox(BuildContext context, TextEditingController controller) {
    return SizedBox(
      width: 50,
      height: 50,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(fontSize: 24),
        decoration: InputDecoration(
          counterText: "",
          contentPadding: const EdgeInsets.all(10),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1.5, color: Color(0xFF1A73E8)),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Color(0xFF1A73E8)),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return ' ';
          }
          return null;
        },
      ),
    );
  }
}
