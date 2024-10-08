import 'package:flutter/material.dart';
import 'package:sjq/models/client.model.dart';
import 'package:sjq/services/user/user.service.dart';
import 'package:sjq/themes/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'meal_plan.dart'; // Import the PlanScreen
import 'package:intl/intl.dart'; // For date formatting

class PlanListScreen extends StatefulWidget {
  const PlanListScreen({super.key});

  @override
  State<PlanListScreen> createState() => _PlanListScreenState();
}

class _PlanListScreenState extends State<PlanListScreen> {
  UserService userService = UserService(); // Use UserService
  List<dynamic> patients = []; // List to hold the patient records

  @override
  void initState() {
    super.initState();
    _loadPatients(); // Load patient records on initialization
  }

  // Method to load the patients for the logged-in user
  Future<void> _loadPatients() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId == null) {
        print('Error: User ID not found in SharedPreferences.');
        return;
      }

      // Fetch the patient records using the UserService method
      dynamic response = await userService.getPatientsByUserId(userId);

      // Check if the response is a Map and extract the relevant data
      if (response is Map<String, dynamic>) {
        setState(() {
          patients = response['patients'] ?? [];
        });
      } else if (response is List<dynamic>) {
        setState(() {
          patients = response;
        });
      } else {
        print('Unexpected response format');
      }
    } catch (e) {
      print('Error loading patient records: $e');
    }
  }

  // Method to get the date of the Monday of the current week
  DateTime _getMondayOfCurrentWeek() {
    DateTime now = DateTime.now();
    int currentWeekday = now.weekday;
    DateTime monday = now.subtract(Duration(days: currentWeekday - 1));
    return monday;
  }

  // Format date to a readable format (e.g., "October 7, 2024")
  String _formatDate(DateTime date) {
    return DateFormat('MMMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorLightBlue,
        title: const Text("Patient Records", style: headingS),
        centerTitle: true,
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        child: patients.isEmpty
            ? const Center(child: CircularProgressIndicator()) // Show loading spinner
            : ListView.builder(
                itemCount: patients.length,
                itemBuilder: (context, index) {
                  final Client patient = patients[index]; // Assuming patients list contains Client objects
                  return GestureDetector(
                    onTap: () {
                      // Get the Monday of the current week
                      DateTime monday = _getMondayOfCurrentWeek();
                      String formattedMonday = _formatDate(monday);

                      // Print the selected patient's ID and week in the console
                      print('Selected patient ID: ${patient.id}');
                      print('Week starting on Monday: $formattedMonday');

                      // Navigate to PlanScreen with patientId and the week (Monday's date)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlanScreen(
                            patientId: patient.id!,
                            weekStartDate: formattedMonday, // Pass the Monday date
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade50, Colors.blue.shade100],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.blue.shade100,
                              child: Text(
                                patient.name != null && patient.name!.isNotEmpty
                                    ? patient.name![0].toUpperCase()
                                    : '?',
                                style: const TextStyle(fontSize: 24, color: Colors.blue),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                patient.name ?? 'Unknown Name',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
