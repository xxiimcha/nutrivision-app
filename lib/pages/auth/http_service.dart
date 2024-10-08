import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sjq/models/event.model.dart'; // Import your Event model

class HttpService {
  final String baseUrl = 'http://localhost:5000/api';

  Future<Map<String, dynamic>> signUp(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/signup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      print('Sign-up response status: ${response.statusCode}');
      print('Sign-up response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to Signup: ${response.body}');
      }
    } catch (e) {
      print('Error during sign-up: $e');
      rethrow;
    }
  }

  Future<void> sendOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/send-otp'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
        }),
      );

      print('Send OTP response status: ${response.statusCode}');
      print('Send OTP response body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Failed to send OTP: ${response.body}');
      }
    } catch (e) {
      print('Error sending OTP: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify-otp'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'otp': otp,
        }),
      );

      print('Verify OTP response status: ${response.statusCode}');
      print('Verify OTP response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to verify OTP: ${response.body}');
      }
    } catch (e) {
      print('Error verifying OTP: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> login(String identifier, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'identifier': identifier,  // Use 'identifier' instead of 'email' if your backend expects it
          'password': password,
        }),
      );

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to login: ${response.body}');
      }
    } catch (e) {
      print('Error during login: $e');
      rethrow;
    }
  }

  // Fetch events from the server
  Future<List<Event>> fetchEvents({String? date}) async {
    try {
      final uri = Uri.parse('$baseUrl/events').replace(queryParameters: {
        if (date != null) 'date': date,
      });

      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print('Fetch events response status: ${response.statusCode}');
      print('Fetch events response body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> eventJson = jsonDecode(response.body);
        return eventJson.map((json) => Event.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load events: ${response.body}');
      }
    } catch (e) {
      print('Error fetching events: $e');
      rethrow;
    }
  }
}
