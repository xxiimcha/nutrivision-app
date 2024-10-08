import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:sjq/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'call_notifier.dart'; // Import the CallNotifier

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const Main());
  } catch (e) {
    print('Error initializing Firebase: $e');
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

class HomePage extends StatefulWidget {
  final String userId; // Example user ID

  const HomePage({Key? key, required this.userId}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CallNotifier? callNotifier;

  @override
  void initState() {
    super.initState();
    // Initialize CallNotifier and start polling
    callNotifier = CallNotifier(userId: widget.userId, context: context);
    callNotifier?.startPolling();
  }

  @override
  void dispose() {
    // Stop the polling when the widget is disposed
    callNotifier?.stopPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Your regular app layout, e.g., a dashboard, settings, etc.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Welcome to the Nutrivision App'),
            Text('This is the Home Page'),
          ],
        ),
      ),
    );
  }
}
