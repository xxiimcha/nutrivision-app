import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';

class CallService {
  late IO.Socket socket;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  // Connect to the Socket.io server
  void connectToServer(String userId, BuildContext context) {
    // Initialize local notifications
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Connect to the Socket.io server
    socket = IO.io('http://localhost:5003', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    // Register the userId with the server
    socket.on('connect', (_) {
      print('Connected to the server');
      socket.emit('register-user', userId); // Register the user with userId
    });

    // Listen for incoming call events
    socket.on('incoming-call', (data) {
      String callerId = data['callerId'];
      String callType = data['callType']; // audio or video
      String roomUrl = data['roomUrl']; // URL to join the call

      print('Incoming $callType call from $callerId');
      showIncomingCallNotification(context, callerId, callType, roomUrl);  // Trigger notification
    });

    // Handle disconnection
    socket.on('disconnect', (_) {
      print('Disconnected from the server');
    });
  }

  // Show the incoming call as a persistent notification
  void showIncomingCallNotification(
      BuildContext context, String callerId, String callType, String roomUrl) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'call_channel', // Channel ID
      'Call Notifications', // Channel name
      channelDescription: 'Incoming call notifications',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Incoming $callType Call',
      'Call from $callerId',
      notificationDetails,
      payload: 'incoming_call',
    );

    // Also show a pop-up dialog for the user to act immediately
    showIncomingCallDialog(context, callerId, callType, roomUrl);
  }

  // Show the dialog for accepting or declining the call
  void showIncomingCallDialog(
      BuildContext context, String callerId, String callType, String roomUrl) {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                joinCall(roomUrl); // Join the call
              },
              child: Text("Accept"),
            ),
            TextButton(
              onPressed: () {
                // Decline the call
                Navigator.of(context).pop();
                print('Call declined');
              },
              child: Text("Decline"),
            ),
          ],
        );
      },
    );
  }

  // Function to open the video/audio call room (e.g., via WebView or other methods)
  void joinCall(String roomUrl) {
    // Implement the code to join the call using WebView or other methods
    print('Joining call at URL: $roomUrl');
  }

  // Disconnect from the server
  void disconnectFromServer() {
    socket.disconnect();
  }
}
