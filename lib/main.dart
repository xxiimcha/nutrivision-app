import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'call.notifier.dart'; // Import CallNotifier
import 'package:provider/provider.dart'; // Import Provider
import 'package:sjq/routes.dart'; // Ensure this points to the correct routes file
import 'package:webview_flutter/webview_flutter.dart'; // Ensure correct import for WebView

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MainApp());
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide the CallNotifier globally
        ChangeNotifierProvider(
          create: (_) => CallNotifier(userId: '67032e49adaa1b6b9c86f2fa'), // Example user ID
        ),
      ],
      child: MaterialApp(
        title: 'Nutrivision',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Using Google Fonts with lexendDeca
          textTheme: GoogleFonts.lexendDecaTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        // Ensure Routes.routes is properly defined in your routes file
        routes: Routes.routes,
        initialRoute: '/', // Define the initial route if necessary
      ),
    );
  }
}
