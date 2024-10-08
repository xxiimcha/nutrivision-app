import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sjq/navigator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _image;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  String _fullName = ''; // Variable to hold the combined firstName and lastName

  // Add variables to hold the initial data for comparison
  String _initialFirstName = '';
  String _initialLastName = '';
  String _initialEmail = '';
  String _initialContact = '';
  String _initialUsername = '';

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
            fullNameController.text = userData['username'] ?? '';
            firstNameController.text = userData['firstName'] ?? '';
            lastNameController.text = userData['lastName'] ?? '';
            emailController.text = userData['email'] ?? '';
            contactController.text = userData['contact'] ?? '';

            // Store the initial values for comparison later
            _initialFirstName = userData['firstName'] ?? '';
            _initialLastName = userData['lastName'] ?? '';
            _initialEmail = userData['email'] ?? '';
            _initialContact = userData['contact'] ?? '';
            _initialUsername = userData['username'] ?? '';

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

  Future<void> _openCamera() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        print('Image picked from camera: ${pickedFile.path}');
      } else {
        print('No image selected from camera.');
      }
    } catch (e) {
      print('Error opening camera: $e');
    }
  }

  Future<void> _openFilePicker() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        print('Image picked from gallery: ${pickedFile.path}');
      } else {
        print('No image selected from gallery.');
      }
    } catch (e) {
      print('Error opening file picker: $e');
    }
  }

  void saveChanges(BuildContext context) async {
    // Check if there are any changes
    if (firstNameController.text == _initialFirstName &&
        lastNameController.text == _initialLastName &&
        emailController.text == _initialEmail &&
        contactController.text == _initialContact &&
        fullNameController.text == _initialUsername) {
      // If no changes were made, show a message and return early
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No changes detected')),
      );
      return; // Exit the function early since there are no changes
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId != null) {
        final updatedUserData = {
          "username": fullNameController.text,
          "firstName": firstNameController.text,
          "lastName": lastNameController.text,
          "email": emailController.text,
          "contact": contactController.text,
        };

        final response = await http.put(
          Uri.parse('http://localhost:5000/api/users/$userId'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(updatedUserData),
        );

        if (response.statusCode == 200) {
          print('User data updated successfully');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Changes saved successfully!'),
            ),
          );

          Timer(const Duration(seconds: 1), () {
            AppNavigator().pop(context);
          });
        } else {
          print('Failed to update user data: ${response.reasonPhrase}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update user data: ${response.reasonPhrase}')),
          );
        }
      } else {
        print('User ID not found in SharedPreferences');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User ID not found')),
        );
      }
    } catch (e) {
      print('Error saving changes: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving changes: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: _image == null
                        ? Image.asset(
                            "assets/avatar/default-profile.png",
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            _image!,
                            width: 180,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Positioned(
                    bottom: 15,
                    right: 15,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text('Choose Image'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _openCamera();
                                  },
                                  child: const Text('Take a Photo',
                                      style: TextStyle(color: Colors.blueAccent)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _openFilePicker();
                                  },
                                  child: const Text('Choose from Gallery',
                                      style: TextStyle(color: Colors.blueAccent)),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
                        child: const Padding(
                          padding: EdgeInsets.all(5),
                          child: Icon(
                            Icons.photo_camera,
                            color: Colors.black54,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                _fullName, // Display the combined firstName and lastName
                style: const TextStyle(
                  fontSize: 28,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 25),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Edit your personal information',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF96B0D7),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Email"),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: 'Input new email',
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text("First Name"),
                      TextField(
                        controller: firstNameController,
                        decoration: const InputDecoration(
                          hintText: 'Input new first name',
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text("Last Name"),
                      TextField(
                        controller: lastNameController,
                        decoration: const InputDecoration(
                          hintText: 'Input new last name',
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text("Username"),
                      TextField(
                        controller: fullNameController,
                        decoration: const InputDecoration(
                          hintText: 'Input new username',
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text("Contact"),
                      TextField(
                        controller: contactController,
                        decoration: const InputDecoration(
                          hintText: 'Input new contact',
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: double.infinity),
                          ElevatedButton(
                            onPressed: () {
                              saveChanges(context);
                            },
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
}
