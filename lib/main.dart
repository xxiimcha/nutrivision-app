import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:sjq/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const Main());
  } catch (e) {
    print('Error initializing Firebase: $e');
    // You can show an error page or do other fallback logic here
  }
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nutrivision',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.lexendDecaTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      routes: Routes.routes, // Start at the '/' route
    );
  }
}

class CallService {
  late IO.Socket socket;  // Marking as `late` to initialize it later

  // Connect to the Socket.io server
  void connectToServer(String userId, BuildContext context) {
    socket = IO.io('http://localhost:5000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    // Register the userId with the server
    socket.on('connect', (_) {
      print('Connected to the server');
      socket.emit('register-user', userId);  // Register the user with userId
    });

    // Listen for incoming call events
    socket.on('incoming-call', (data) {
      String callerId = data['callerId'];
      String callType = data['callType'];  // audio or video

      // Handle the incoming call notification
      print('Incoming $callType call from $callerId');
      showIncomingCallDialog(context, callerId, callType);
    });

    // Handle disconnection
    socket.on('disconnect', (_) {
      print('Disconnected from the server');
    });
  }

  // Disconnect from the server
  void disconnectFromServer() {
    socket.disconnect();
  }
}

void showIncomingCallDialog(BuildContext context, String callerId, String callType) {
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
              // You can add logic to handle accepting the call here
            },
            child: Text("Accept"),
          ),
          TextButton(
            onPressed: () {
              // Decline the call
              Navigator.of(context).pop();
              print('Call declined');
              // You can add logic to handle declining the call here
            },
            child: Text("Decline"),
          ),
        ],
      );
    },
  );
}
