import 'package:flutter/material.dart';
import 'package:sjq/navigator.dart';
import 'package:sjq/pages/profile/profile_buttons.dart';
import 'package:sjq/themes/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _fullName = ''; // Variable to hold the full name

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user data when screen is initialized
  }

  Future<void> _loadUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId != null) {
        print('User ID found in SharedPreferences: $userId');
        
        // Replace with your backend endpoint to fetch user data
        final response = await http.get(Uri.parse('http://localhost:5000/api/users/$userId'));

        print('HTTP GET request sent to: http://localhost:5000/api/users/$userId');
        print('Response status code: ${response.statusCode}');
        
        if (response.statusCode == 200) {
          final userData = jsonDecode(response.body);
          print('User data fetched successfully: $userData');

          setState(() {
            // Combine firstName and lastName
            _fullName = '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}'.trim();
          });
        } else {
          print('Failed to load user data: ${response.reasonPhrase}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load user data: ${response.reasonPhrase}')),
          );
        }
      } else {
        print('User ID not found in SharedPreferences');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User ID not found')),
        );
      }
    } catch (e) {
      print('Error loading user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading user data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Make the background color white
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 60),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    "assets/avatar/default-profile.png",
                    width: MediaQuery.of(context).size.width * 0.4, // Make the image size responsive
                    height: MediaQuery.of(context).size.width * 0.4, // Make the image size responsive
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _fullName.isNotEmpty ? _fullName : 'Loading...', // Display the user's name or a loading message
                  style: headingM,
                ),
                const SizedBox(height: 15),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadiusDirectional.only(
                      topStart: Radius.circular(30),
                      topEnd: Radius.circular(30),
                    ),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Profile", style: headingS),
                        CustomButton(
                          title: "Personal Information",
                          onPressed: () {
                            AppNavigator().toEditProfileScreen(context);
                          },
                          icon: Icons.person,
                        ),
                        const SizedBox(height: 5),
                        CustomButton(
                          title: "Nutritional Status",
                          onPressed: () {
                            AppNavigator().toUpdateNutritionStats(context);
                          },
                          icon: Icons.assignment_turned_in,
                        ),
                        const SizedBox(height: 15),
                        const Text("Security", style: paragraphM),
                        CustomButton(
                          title: "ChangePassword",
                          onPressed: () {
                            AppNavigator().toChangePassword(context);
                          },
                          icon: Icons.lock_person,
                        ),
                        const SizedBox(height: 10),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: double.infinity,
                            ),
                            AboutButton(),
                            SizedBox(height: 25),
                            LogoutButton()
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
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.title,
    required this.onPressed,
    required this.icon,
  });

  final String title;
  final Function() onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 10),
            child: Row(
              children: [
                Icon(icon, color: Colors.black87),
                const SizedBox(width: 20),
                Text(
                  title,
                  style: paragraphM.copyWith(
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.black87),
        ],
      ),
    );
  }
}
