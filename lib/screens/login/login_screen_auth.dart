import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gas_leakage_survey/screens/home_screen.dart';

class LogInAuth extends StatefulWidget {
  const LogInAuth({Key? key}) : super(key: key);

  @override
  State<LogInAuth> createState() => _LogInAuthState();
}

class _LogInAuthState extends State<LogInAuth> {
  final _linkController = TextEditingController();
  bool _isLoading = false;

  Future<void> _authenticateWithLink() async {
    setState(() {
      _isLoading = true;
    });

    final link = _linkController.text.trim();
    // Make an HTTP request to your backend API to authenticate with the provided link
    final response = await http.post(
      Uri.parse('https://picarro-backend.onrender.com/'),
      body: {'link': link},
    );

    if (response.statusCode == 200) {
      // If authentication is successful, navigate to the home screen
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const HomeScreen()),
      // );
    } else {
      // Handle authentication failure, show error message, etc.
      print('Authentication failed');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF222831),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 90, horizontal: 30),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/login_icon_2.png",
                      width: 180,
                      height: 180,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Please provide the link to authenticate.",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.white24,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _linkController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Link',
                      labelStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(Icons.link, color: Colors.white),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF76ABAE)),
                      ),
                      filled: true,
                      fillColor: Color(0xFF31363F),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  _isLoading
                      ? CircularProgressIndicator()
                      : MaterialButton(
                    onPressed: _authenticateWithLink,
                    color: Color(0xFF76ABAE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minWidth: double.infinity,
                    height: 60,
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(fontSize: 17, color: Colors.black),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
