import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gas_leakage_survey/raise_ticket_screen_options/form_fill.dart';
import 'package:gas_leakage_survey/screens/home_screen.dart';
import 'package:gas_leakage_survey/screens/login/login_screen.dart';
import 'package:gas_leakage_survey/screens/login/login_screen_new.dart';
import 'package:gas_leakage_survey/screens/raise_ticket_screen.dart';
import 'package:gas_leakage_survey/screens/raise_ticket_screen_options.dart';
import 'package:gas_leakage_survey/splash.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}
class SomethingWentWrongWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Oops! Something went wrong while initializing Firebase.',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize Firebase asynchronously
      future: Firebase.initializeApp(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Firebase initialization completed, build your app
          print('Firebase initialized successfully!');
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            home: const LogInNew(),
          );
        } else if (snapshot.hasError) {
          // Firebase initialization failed, handle error
          print('Error initializing Firebase: ${snapshot.error}');
          return SomethingWentWrongWidget(); // Display an error message
        } else {
          // Show a loading indicator while Firebase initializes
          print('Initializing Firebase...');
          return CircularProgressIndicator();
        }
      },

    );
  }
}
