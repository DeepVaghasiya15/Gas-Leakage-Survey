import 'package:flutter/material.dart';
import 'package:gas_leakage_survey/raise_ticket_screen_options/form_fill.dart';
import 'package:gas_leakage_survey/screens/home_screen.dart';
import 'package:gas_leakage_survey/screens/login/login_screen.dart';
import 'package:gas_leakage_survey/screens/login/login_screen_new.dart';
import 'package:gas_leakage_survey/screens/raise_ticket_screen.dart';
import 'package:gas_leakage_survey/screens/raise_ticket_screen_options.dart';
import 'package:gas_leakage_survey/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // routes: {
      //   '/': (context) => HomeScreen(isSurveyInProgress: false),
      //   '/formfill': (context) => FormFill()
      // },
      // home: const HomeScreen(isSurveyInProgress: false,),
      // home: const LogIn(),
      // home: SplashScreen(), //main
      // home: FormFill(),
      // home: RaiseTicketScreenOptions(isSurveyInProgress: true,),
      home: const LogInNew(),
    );
  }
}