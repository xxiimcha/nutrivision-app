import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'package:sjq/models/client.model.dart';
import 'package:sjq/themes/themes.dart';

class PatientDetailsScreen extends StatelessWidget {
  final Client patient;

  const PatientDetailsScreen({Key? key, required this.patient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient Details", style: headingS),
        backgroundColor: colorLightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            _buildDetailCard(Icons.person, 'Name', patient.name ?? 'Unknown Name'),
            _buildDetailCard(Icons.family_restroom, 'Guardian', patient.guardian ?? 'Unknown Guardian'),
            _buildDetailCard(Icons.cake, 'Date of Birth', _formatDate(patient.dob) ?? 'Unknown'),
            _buildDetailCard(Icons.male, 'Gender', patient.gender ?? 'Unknown'),
            _buildDetailCard(Icons.height, 'Height', '${patient.height ?? 'Unknown'} cm'),
            _buildDetailCard(Icons.monitor_weight, 'Weight', '${patient.weight ?? 'Unknown'} kg'),
            _buildDetailCard(Icons.date_range, 'Date of Weighing', _formatDate(patient.dateOfWeighing) ?? 'Unknown'),
            _buildDetailCard(Icons.line_weight, 'Weight for Age', patient.weightForAge ?? 'Unknown'),
            _buildDetailCard(Icons.height, 'Height for Age', patient.heightForAge ?? 'Unknown'),
            _buildDetailCard(Icons.line_weight_outlined, 'Weight for Height', patient.weightForHeight ?? 'Unknown'),
            _buildDetailCard(Icons.food_bank, 'Nutrition Status', patient.nutritionStatus ?? 'Unknown'),
          ],
        ),
      ),
    );
  }

  // Helper function to build a detailed card for each item
  Widget _buildDetailCard(IconData icon, String label, String value) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: colorLightBlue, size: 30),
        title: Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
        subtitle: Text(value, style: paragraphS),
      ),
    );
  }

  // Helper method to format the date to 'YYYY-MM-DD'
  String? _formatDate(String? date) {
    if (date == null) return null;
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat('yyyy-MM-dd').format(parsedDate); // Format date to 'YYYY-MM-DD'
    } catch (e) {
      return 'Invalid date'; // Fallback if date parsing fails
    }
  }
}
