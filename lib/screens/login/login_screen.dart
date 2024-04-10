import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gas_leakage_survey/screens/home_screen.dart';
import 'package:http/http.dart' as http;

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  TextEditingController _phoneController = TextEditingController(text: "1234657890");
  TextEditingController _passwordController = TextEditingController(text: "123");

  // final _phoneController = TextEditingController();
  // final _passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final phoneNumber = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    if (phoneNumber.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a phone number and password')),
      );
      return;
    }
    try {
      print('before api call');
      print('Request payload: ${json.encode({
        'phone': phoneNumber,
        'password': password,
      })}');
      final response = await http.post(
        Uri.parse('https://picarro-backend.onrender.com/users/login'),
        headers: {
          'Content-Type': 'application/json', // Specify JSON content type
        },
        body: json.encode({
          'phone': phoneNumber,
          'password': password,
        }),
      );
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('after api call');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final token = jsonResponse['token'];
        print('Token: $token');

        // Store the token in the secure storage.
        final secureStorage = FlutterSecureStorage();
        await secureStorage.write(key: 'token', value: token);

        // Navigate to the home screen.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        // Handle the error.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed')),
        );
      }
    } catch (e) {
      // Handle the exception.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed')),
      );
    }
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
                  const SizedBox(height: 50),
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
                  const SizedBox(height: 1),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Please sign in to continue.",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.white24,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(Icons.phone, color: Colors.white),
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
                  const SizedBox(height: 10),
                  StatefulBuilder(
                    builder: (context, setState) {
                      return TextField(
                        controller: _passwordController,
                        style: const TextStyle(color: Colors.white),
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.white),
                          prefixIcon: const Icon(Icons.lock_outline_rounded, color: Colors.white),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF76ABAE)),
                          ),
                          filled: true,
                          fillColor: Color(0xFF31363F),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  MaterialButton(
                    onPressed: _login,
                    // onPressed: () {
                    //   Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                    // },
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