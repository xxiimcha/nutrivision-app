import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For decoding the JSON response
import 'pages/chat/call.dart';

class CallNotifier extends ChangeNotifier {
  final String userId;
  Timer? _pollingTimer;

  CallNotifier({required this.userId});

  // Start polling the server every second
  void startPolling(BuildContext context) {
    debugPrint('Polling started for user: $userId');
    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      // Call the API to check for incoming calls
      final incomingCall = await checkForIncomingCall(userId);
      
      if (incomingCall != null && incomingCall.containsKey('roomLink')) {
        final String roomLink = incomingCall['roomLink']!;
        final String callId = incomingCall['_id']; // Assuming `_id` is the call ID
        
        // Print the room link to the console
        debugPrint('Room link fetched: $roomLink');
        
        // Show the call dialog with the roomLink and callId
        showCallDialog(context, roomLink, callId);
      }
    });
  }

  // Function to call the API and check for incoming calls
  Future<Map<String, dynamic>?> checkForIncomingCall(String userId) async {
    try {
      final response = await http.get(Uri.parse('http://localhost:5000/api/calls/$userId'));

      if (response.statusCode == 200) {
        final List<dynamic> calls = json.decode(response.body);
        if (calls.isNotEmpty) {
          // Assuming we're getting a list of calls and picking the first one for simplicity
          return calls.first;
        }
      } else {
        debugPrint('Error fetching calls: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error making API request: $e');
    }

    return null; // Return null if no calls found or an error occurred
  }

  // Stop polling when necessary
  void stopPolling() {
    debugPrint('Polling stopped for user: $userId');
    _pollingTimer?.cancel();
  }

  @override
  void dispose() {
    stopPolling();
    super.dispose();
  }
}

// Function to update the call status
Future<bool> updateCallStatus(String callId, String status) async {
  try {
    final response = await http.post(
      Uri.parse('http://localhost:5000/api/calls/$callId/status'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'status': status,
      }),
    );

    if (response.statusCode == 200) {
      debugPrint('Call status updated to $status');
      return true;
    } else {
      debugPrint('Failed to update call status: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('Error updating call status: $e');
  }

  return false; // Return false if the status update failed
}

// Function to show the call dialog
void showCallDialog(BuildContext context, String roomLink, String callId) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissing by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Incoming Call'),
        content: const Text('You have an incoming call.'),
        actions: <Widget>[
          TextButton(
            child: const Text('Decline'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              debugPrint('Call Declined');
              // Optionally, update the status to 'declined'
              updateCallStatus(callId, 'declined');
            },
          ),
          ElevatedButton(
            child: const Text('Accept'),
            onPressed: () async {
              // Update call status to 'accepted'
              bool statusUpdated = await updateCallStatus(callId, 'accepted');

              if (statusUpdated) {
                Navigator.of(context).pop(); // Close the dialog
                // Open the call room link in WebView
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CallWebView(roomLink: roomLink),
                  ),
                );
              } else {
                debugPrint('Failed to update call status.');
              }
            },
          ),
        ],
      );
    },
  );
}
