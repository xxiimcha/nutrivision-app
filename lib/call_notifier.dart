import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CallNotifier {
  Timer? _pollingTimer;
  final String userId; // ID of the user to check for incoming calls
  final BuildContext context; // Reference to the app's context to show alerts

  CallNotifier({required this.userId, required this.context});

  // Start polling for incoming calls
  void startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _checkForIncomingCalls();
    });
  }

  // Stop polling for incoming calls
  void stopPolling() {
    _pollingTimer?.cancel();
  }

  // Poll the server for incoming calls
  Future<void> _checkForIncomingCalls() async {
    try {
      // Replace with your API endpoint to check for incoming calls
      final response = await http.get(Uri.parse('http://localhost:5000/api/calls/check/$userId'));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // If there is an incoming call, show an alert dialog
        if (responseData['hasIncomingCall'] == true) {
          String callerId = responseData['callerId'];
          String callType = responseData['callType']; // 'audio' or 'video'
          _showIncomingCallDialog(callerId, callType);
        }
      } else {
        print('Failed to check incoming calls: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error checking for incoming calls: $e');
    }
  }

  // Show an alert dialog when there is an incoming call
  void _showIncomingCallDialog(String callerId, String callType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Incoming $callType Call"),
          content: Text("Call from $callerId"),
          actions: [
            TextButton(
              onPressed: () {
                // Accept the call
                Navigator.of(context).pop();
                print('Call accepted');
                // Add your call handling logic here (like navigating to a call screen)
              },
              child: const Text("Accept"),
            ),
            TextButton(
              onPressed: () {
                // Decline the call
                Navigator.of(context).pop();
                print('Call declined');
                // Add any necessary logic for declining the call
              },
              child: const Text("Decline"),
            ),
          ],
        );
      },
    );
  }
}
