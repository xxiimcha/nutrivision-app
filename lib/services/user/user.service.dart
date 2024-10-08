import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sjq/models/client.model.dart';

class UserService {
  final String baseUrl = 'http://localhost:5000/api';

  // Method to create a patient record
  Future<void> createEntry(Client client) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/patients/create'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(client.toJson()),
      );

      if (response.statusCode == 201) {
        print('Patient record created successfully');
      } else {
        print('Failed to create patient record with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to create patient record: ${response.body}');
      }
    } catch (e) {
      print('Error creating patient record: $e');
      rethrow;
    }
  }

  // Method to fetch patients by user ID
  Future<List<Client>> getPatientsByUserId(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/patients/$userId'),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        // Access the 'patients' key
        List<dynamic> patientsData = data['patients'];

        return patientsData.map((json) => Client.fromJson(json)).toList();
      } else {
        print('Failed to fetch patients with status code: ${response.statusCode}');
        throw Exception('Failed to fetch patients');
      }
    } catch (e) {
      print('Error fetching patients: $e');
      rethrow;
    }
  }
}
