import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CallNotifier extends StatefulWidget {
  final String userId; // ID of the logged-in user

  CallNotifier({required this.userId});

  @override
  _CallNotifierState createState() => _CallNotifierState();
}

class _CallNotifierState extends State<CallNotifier> {
  Timer? _timer;
  Map<String, dynamic>? incomingCall;

  @override
  void initState() {
    super.initState();
    // Start polling every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) => _pollForIncomingCall());
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  // Polling for incoming call signals
  Future<void> _pollForIncomingCall() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5000/api/calls/${widget.userId}'),
      );

      if (response.statusCode == 200) {
        List<dynamic> calls = json.decode(response.body);

        if (calls.isNotEmpty && incomingCall == null) {
          // If there is an incoming call, show a pop-up
          setState(() {
            incomingCall = calls[0];
          });
          _showIncomingCallDialog();
        }
      } else {
        print('Failed to load calls');
      }
    } catch (error) {
      print('Error polling for calls: $error');
    }
  }

  // Updating call status (answered/declined)
  Future<void> _updateCallStatus(String callId, String status) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/api/calls/$callId/status'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'status': status,
        }),
      );

      if (response.statusCode == 200) {
        print('Call status updated successfully');
      } else {
        print('Failed to update call status');
      }
    } catch (error) {
      print('Error updating call status: $error');
    }
  }

  // Show a dialog when an incoming call is detected
  void _showIncomingCallDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent the user from dismissing the dialog without action
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Incoming Call'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Incoming call from: ${incomingCall!['callerId']}'),
              Text('Call Type: ${incomingCall!['callType']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: _acceptCall,
              child: Text('Accept'),
            ),
            TextButton(
              onPressed: _declineCall,
              child: Text('Decline'),
            ),
          ],
        );
      },
    );
  }

  // Accepting the call
  void _acceptCall() {
    if (incomingCall != null) {
      _updateCallStatus(incomingCall!['_id'], 'answered'); // Update status to "answered"
      setState(() {
        incomingCall = null;
      });
      Navigator.of(context).pop(); // Close the dialog after accepting the call
    }
  }

  // Declining the call
  void _declineCall() {
    if (incomingCall != null) {
      _updateCallStatus(incomingCall!['_id'], 'declined'); // Update status to "declined"
      setState(() {
        incomingCall = null;
      });
      Navigator.of(context).pop(); // Close the dialog after declining the call
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Call Notifier')),
      body: Center(
        child: Text('Waiting for incoming calls...'),
      ),
    );
  }
}