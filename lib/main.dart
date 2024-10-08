import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gas_leakage_survey/screens/login/user_profiles_screen.dart';
import 'package:gas_leakage_survey/shared_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gas_leakage_survey/screens/home_screen.dart';
import 'package:gas_leakage_survey/screens/login/login_screen_new.dart';
import 'package:gas_leakage_survey/screens/raise_ticket_screen.dart';
import 'package:gas_leakage_survey/screens/raise_ticket_screen_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // static const String KEYLOGIN = "login";
  // final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // navigatorObservers: [routeObserver],
      debugShowCheckedModeBanner: false,
      title: 'Gas Leakage',
      initialRoute: '/',
      routes: {
        // '/': (context) => FutureBuilder<bool>(
        //   future: isLoggedIn(),
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       return snapshot.data! ? const HomeScreen(isSurveyInProgress: false) : const LogInNew();
        //     } else {
        //       return const CircularProgressIndicator(); // or any other loading indicator
        //     }
        //   },
        // ),
        '/': (context) => const LogInNew(),
        // '/': (context) => const UserProfileScreen(),
        '/homescreen': (context) => const HomeScreen(isSurveyInProgress: false),
        '/raiseticketscreen': (context) => const RaiseTicketScreenOptions(isSurveyInProgress: false),
      },
    );
  }

  // static Future<bool> isLoggedIn() async {
  //   var sharedPref = await SharedPreferences.getInstance();
  //   return sharedPref.getBool(KEYLOGIN) ?? false;
  // }
}
