import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:tedz/login1.dart';
import 'auth_service.dart';
import 'HomePage.dart';
import 'firebase_options.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'dart:async';  // Import for Timer and Future

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  try {
    // Initialize App Check
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
      // iosProvider: IOSProvider.deviceCheck,  // Use DeviceCheck for iOS (if applicable)
    );
    print('App Check activated successfully');

    // Fetch App Check token with retries and exponential backoff
    await fetchAppCheckToken();
    print('App Check token retrieved successfully');
  } catch (e) {
    print('Error activating App Check or retrieving token: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> fetchAppCheckToken() async {
  const maxRetries = 5;
  var retries = 0;

  while (retries < maxRetries) {
    try {
      await FirebaseAppCheck.instance.getToken(true);
      // Token retrieval succeeded
      break;
    } catch (e) {
      retries++;
      if (retries >= maxRetries) {
        throw Exception('Failed to retrieve App Check token after $maxRetries attempts');
      }
      // Exponential backoff
      await Future.delayed(Duration(seconds: 2 * retries));
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const LoginPage(),
        '/loginScreen': (context) => const LoginScreen(),
        '/registerScreen': (context) => RegisterScreen(),
        '/home': (context) => const Home(),
      },
      initialRoute: '/',
    );
  }
}
