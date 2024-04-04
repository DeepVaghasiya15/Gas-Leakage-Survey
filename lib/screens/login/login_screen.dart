import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gas_leakage_survey/screens/home_screen.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;
  String _passwordText = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF222831),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        )),
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
                              fontSize: 24),
                        )),
                    const SizedBox(
                      height: 1,
                    ),
                    const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Please signin to continue.",
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.white24,
                              fontSize: 14),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _emailController,
                      style: const TextStyle(
                          color: Colors.white), // Set text color to white
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                            color: Colors.white), // Set label color to white
                        prefixIcon: Icon(Icons.email_outlined,
                            color: Colors.white), // Set icon color to white
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white), // Set border color to white
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  Color(0xFF76ABAE)), // Border color when focused
                        ),
                        filled: true,
                        fillColor:
                            Color(0xFF31363F), // Background color for text area
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _passwordController,
                      style: const TextStyle(
                          color: Colors.white), // Set text color to white
                      obscureText:
                          !_passwordVisible, // Toggle visibility based on _passwordVisible
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(
                            color: Colors.white), // Set label color to white
                        prefixIcon: const Icon(Icons.lock_outline_rounded,
                            color: Colors.white), // Set icon color to white
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white), // Set border color to white
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  Color(0xFF76ABAE)), // Border color when focused
                        ),
                        filled: true,
                        fillColor:
                        const Color(0xFF31363F), // Background color for text area
                      ),
                    ),
                    const SizedBox(height: 40,),
                    MaterialButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                      },
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
                ))
          ],
        ),
      ),
    );
  }
}
