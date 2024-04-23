import 'package:flutter/material.dart';
import 'package:gas_leakage_survey/screens/login/login_screen.dart';
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
      backgroundColor: Color(0xFF222831),
      child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
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
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          decoration: BoxDecoration(
            color: Color(0xFF31363F), // Set your desired background color here
            borderRadius: BorderRadius.circular(10.0), // Set your desired border radius here
          ),
          // color: Color(0xFF31363F), // Set your desired background color here
          child: ListTile(
            title: const Text(
              'Home',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
            ),
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => const SpeakersScreen()));
            },
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          decoration: BoxDecoration(
            color: Color(0xFF31363F), // Set your desired background color here
            borderRadius: BorderRadius.circular(10.0), // Set your desired border radius here
          ),
          // color: Color(0xFF31363F), // Set your desired background color here
          child: ListTile(
            title: const Text(
              'History',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryScreen()));
            },
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          decoration: BoxDecoration(
            color: Color(0xFF31363F), // Set your desired background color here
            borderRadius: BorderRadius.circular(10.0), // Set your desired border radius here
          ),
          // color: Color(0xFF31363F), // Set your desired background color here
          child: ListTile(
            title: const Text(
              'Pending Route',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
            ),
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => const SpeakersScreen()));
            },
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          decoration: BoxDecoration(
            color: Color(0xFF31363F), // Set your desired background color here
            borderRadius: BorderRadius.circular(10.0), // Set your desired border radius here
          ),
          // color: Color(0xFF31363F), // Set your desired background color here
          child: ListTile(
            title: const Text(
              'Change Password',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
            ),
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => const SpeakersScreen()));
            },
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          decoration: BoxDecoration(
            color: Color(0xFF31363F), // Set your desired background color here
            borderRadius: BorderRadius.circular(10.0), // Set your desired border radius here
          ),
          // color: Color(0xFF31363F), // Set your desired background color here
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
