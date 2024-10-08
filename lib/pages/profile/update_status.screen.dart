import 'package:flutter/material.dart';
import 'package:sjq/models/client.model.dart';
import 'package:sjq/services/user/user.service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateStatusScreen extends StatefulWidget {
  const UpdateStatusScreen({super.key});

  @override
  State<UpdateStatusScreen> createState() => _UpdateStatusScreenState();
}

class _UpdateStatusScreenState extends State<UpdateStatusScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Status"),
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
                      // Navigate to a new screen to display improvements
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PatientImprovementScreen(patientId: patient.id!),
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

class PatientImprovementScreen extends StatefulWidget {
  final String patientId;

  const PatientImprovementScreen({Key? key, required this.patientId}) : super(key: key);

  @override
  State<PatientImprovementScreen> createState() => _PatientImprovementScreenState();
}

class _PatientImprovementScreenState extends State<PatientImprovementScreen> {
  List<dynamic> improvements = []; // List to hold the weekly improvements
  bool isLoading = true; // To show a loading spinner
  UserService userService = UserService(); // Instance of UserService

  @override
  void initState() {
    super.initState();
    _loadImprovements(); // Load weekly improvements on initialization
  }

  // Method to load weekly improvements based on patientId
  Future<void> _loadImprovements() async {
    try {
      final response = await userService.getWeeklyImprovementsByPatientId(widget.patientId);
      setState(() {
        improvements = response; // Update improvements list
        isLoading = false;
      });
    } catch (e) {
      print('Error loading improvements: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Display the improvements in a table
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Improvements'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                child: improvements.isEmpty
                    ? const Center(child: Text('No improvements found.'))
                    : Table(
                        border: TableBorder.all(color: Colors.black26),
                        children: [
                          const TableRow(
                            decoration: BoxDecoration(color: Colors.grey),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Week Number',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Improvement',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          // Populate the table with improvements
                          ...improvements.map((improvement) {
                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(improvement['weekNumber'].toString()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(improvement['improvement'].toString()),
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
              ),
            ),
    );
  }
}