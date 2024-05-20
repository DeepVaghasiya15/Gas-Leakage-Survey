import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gas_leakage_survey/screens/home_screen.dart';
import 'package:gas_leakage_survey/screens/login/user_profiles_screen.dart';
import 'package:http/http.dart' as http;
import 'package:gas_leakage_survey/model/tokenModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/raise_ticket_data.dart';
import '../../shared_preference.dart';

late String Token;
class LogInNew extends StatefulWidget {
  const LogInNew({Key? key}) : super(key: key);

  @override
  _LogInNewState createState() => _LogInNewState();
}

class _LogInNewState extends State<LogInNew> {

  // TextEditingController _phoneController = TextEditingController(text: "888");
  // TextEditingController _passwordController = TextEditingController(text: "123");
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _saveCredentials = false;

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _phoneController.text = prefs.getString('savedProjectId') ?? '';
      _passwordController.text = prefs.getString('savedPassword') ?? '';
      _saveCredentials = prefs.getBool('saveCredentials') ?? false;
    });
  }

  Future<void> _login() async {
    final phoneNumber = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    projectId = _phoneController.text;

    if (phoneNumber.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a phone number and password')),
      );
      return;
    }
    try {
      print('before api call');
      print('Request payload: ${json.encode({
        'organization_id': phoneNumber,
        'password': password,
      })}');
      final response = await http.post(
        Uri.parse('$baseUrl$loginEndpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'organization_id': phoneNumber,
          'password': password,
        }),
      );
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('after api call');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final token = jsonResponse['data']['token'];

        print('Token: $token');
        tokenUser = token;
        print('tokenUser: $tokenUser');

        // Store the token in the secure storage.
        final secureStorage = FlutterSecureStorage();
        await secureStorage.write(key: 'token', value: token);

        if (_saveCredentials) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('savedProjectId', phoneNumber);
          await prefs.setString('savedPassword', password);
          await prefs.setBool('saveCredentials', true);
        } else {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('savedProjectId');
          await prefs.remove('savedPassword');
          await prefs.setBool('saveCredentials', false);
        }

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserProfileScreen()));
        SharedPreferencesHelper.saveLoginState(true);
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
      backgroundColor: const Color(0xFF292C3D),
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
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.0),
                  child: Align(
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
                ),
                const SizedBox(height: 1),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Please sign in to continue.",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
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
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Project ID',
                      labelStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(Icons.card_travel_rounded, color: Colors.white),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFEFFF00)),
                      ),
                      filled: true,
                      fillColor: Color(0xFF393B50),
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
                            borderSide: BorderSide(color: Color(0xFFEFFF00)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFEFFF00)),
                          ),
                          filled: true,
                          fillColor: Color(0xFF393B50),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _saveCredentials,
                        onChanged: (bool? newValue) {
                          setState(() {
                            _saveCredentials = newValue ?? false;
                          });
                        },
                      ),
                      const Text(
                        'Remember me',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 35),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: MaterialButton(
                    onPressed: _login,
                    // onPressed: () {
                    //   HapticFeedback.vibrate();
                    //   // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(isSurveyInProgress: false,)));
                    //   Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfileScreen()));
                    // },
                    color: Color(0xFFEFFF00),
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