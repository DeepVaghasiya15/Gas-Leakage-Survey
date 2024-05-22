import 'package:flutter/material.dart';
import 'package:gas_leakage_survey/screens/login/login_screen_new.dart';
import 'package:gas_leakage_survey/screens/side_drawer/drawer_screens/history_screen.dart';

class DrawerHomeScreen extends StatefulWidget {
  const DrawerHomeScreen({super.key});

  @override
  State<DrawerHomeScreen> createState() => _DrawerHomeScreenState();
}

class _DrawerHomeScreenState extends State<DrawerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF222831),
      child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        // Drawer Header Logo
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Color(0xFFEFFF00),
          ),
          child: Center(
            child: Image.asset(
              'assets/images/joslerBlack.png',
              width: 220,
              height: 220,
            ),
          ),
        ),

        // Home Button
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFF31363F), // Set your desired background color here
            borderRadius: BorderRadius.circular(10.0), // Set your desired border radius here
          ),
          child: ListTile(
            title: const Text(
              'Home',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),

        // LogOut button
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFF31363F), // Set your desired background color here
            borderRadius: BorderRadius.circular(10.0), // Set your desired border radius here
          ),
          child: ListTile(
            title: const Text(
              'Log Out',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LogInNew()));
            },
          ),
        )
      ]),
    );
  }
}
