import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gas_leakage_survey/screens/home_screen.dart';
import 'package:http/http.dart' as http;

class LogInNew extends StatefulWidget {
  const LogInNew({Key? key}) : super(key: key);

  @override
  _LogInNewState createState() => _LogInNewState();
}

class _LogInNewState extends State<LogInNew> {

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
          MaterialPageRoute(builder: (context) => HomeScreen(isSurveyInProgress: false,)),
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
      // backgroundColor: Color(0xFF222831),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Align(
                    // alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/pipeline1.png",
                      width: 369,
                      height: 288,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Please sign in to continue.",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(Icons.phone, color: Colors.black),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return TextField(
                        controller: _passwordController,
                        style: const TextStyle(color: Colors.black),
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.black),
                          prefixIcon: const Icon(Icons.lock_outline_rounded, color: Colors.black),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: MaterialButton(
                    // onPressed: _login,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(isSurveyInProgress: false,)));
                    },
                    color: Color(0xFFFFC604),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minWidth: double.infinity,
                    height: 60,
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(fontSize: 17, color: Colors.black),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}