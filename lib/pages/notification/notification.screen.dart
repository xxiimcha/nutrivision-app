import 'package:flutter/material.dart';
import 'package:sjq/themes/themes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId != null) {
        final response = await http.get(
          Uri.parse('http://localhost:5000/api/notifications/$userId'),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          setState(() {
            notifications = List<Map<String, dynamic>>.from(data);
          });
        } else {
          print('Failed to load notifications: ${response.reasonPhrase}');
        }
      } else {
        print('User ID not found in SharedPreferences');
      }
    } catch (e) {
      print('Error loading notifications: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification", style: headingM),
        backgroundColor: colorLightBlue,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (notifications.isNotEmpty)
                for (var notification in notifications) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(_formatDate(notification['createdAt']), style: headingM),
                  ),
                  MessageItemNotification(
                    title: notification['title'],
                    message: notification['message'],
                    time: _formatTime(notification['createdAt']),
                  ),
                ]
              else
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('No notifications available', style: headingM),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    DateTime now = DateTime.now();

    if (DateFormat('yyyy-MM-dd').format(dateTime) == DateFormat('yyyy-MM-dd').format(now)) {
      return "Now";
    } else if (DateFormat('yyyy-MM-dd').format(dateTime) ==
        DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 1)))) {
      return "Yesterday";
    } else {
      return DateFormat('MMMM dd, yyyy').format(dateTime); // Format as "F y, f"
    }
  }

  String _formatTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat('h:mm a').format(dateTime);
  }
}

class MessageItemNotification extends StatelessWidget {
  final String title;
  final String message;
  final String time;

  const MessageItemNotification({
    super.key,
    required this.title,
    required this.message,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.notifications)),
      title: Text(title, style: headingS),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message, style: paragraphM),
          Text(time, style: paragraphS),
        ],
      ),
    );
  }
}
