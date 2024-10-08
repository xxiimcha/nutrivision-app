import 'package:flutter/material.dart';
import 'http_service.dart'; // Import the HTTP service

class VerifyEmailPage extends StatefulWidget {
  final String email;
  final HttpService httpService;

  const VerifyEmailPage({Key? key, required this.email, required this.httpService}) : super(key: key);

  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final List<TextEditingController> _otpControllers = List.generate(4, (index) => TextEditingController());

  void _onConfirm() async {
    try {
      final otp = _otpControllers.map((controller) => controller.text).join();
      final response = await widget.httpService.verifyOtp(widget.email, otp);

      print('OTP verification response: $response');

      if (response.containsKey('msg') && response['msg'] == 'OTP verified successfully') {
        // Handle successful verification
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email verified successfully!')),
        );

        // Navigate back to the login page
        Navigator.pushReplacementNamed(context, '/login'); // Use the correct route name for your login page
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to verify OTP: ${response['msg']}')),
        );
      }
    } catch (e) {
      print('Error verifying OTP: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to verify OTP: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Verify your email",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E4DB7), // Adjusted to match your design color
              ),
            ),
            SizedBox(height: 10),
            Text(
              "A verification email has been sent to your email address. Please check your email to verify your account.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 80),
            Text(
              "Please enter the 4 digit code sent to ${widget.email}",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF1E4DB7), // Adjusted to match your design color
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (index) {
                return Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey, width: 2),
                  ),
                  child: TextField(
                    controller: _otpControllers[index],
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 3) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                  ),
                );
              }),
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: () async {
                try {
                  await widget.httpService.sendOtp(widget.email);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('OTP resent to ${widget.email}')),
                  );
                } catch (e) {
                  print('Error resending OTP: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to resend OTP: $e')),
                  );
                }
              },
              child: Center(
                child: Text(
                  "RESEND CODE?",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF1E4DB7), // Adjusted to match your design color
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            SizedBox(height: 70),
            Center(
              child: ElevatedButton(
                onPressed: _onConfirm,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Color(0xFF1E4DB7), // Button color adjusted to match your design
                ),
                child: Text(
                  "CONFIRM",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
