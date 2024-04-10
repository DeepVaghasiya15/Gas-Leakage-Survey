import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gas_leakage_survey/screens/home_screen.dart';
import 'package:gas_leakage_survey/screens/login/login_screen.dart';
import 'package:gas_leakage_survey/screens/login/login_screen_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // Start a timer to navigate to the HomeScreen after 5 seconds
    Timer(Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => LogIn()),
      );
    });
    // Start a timer to animate the opacity of the text after 1 second
    Timer(Duration(seconds: 0), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF222831),
      body: Stack(
        children: [
          Center(
            child: Image.asset("assets/images/pipegas.gif"),
          ),
          Positioned(
            // Adjust the position as needed
            top: 80,
            left: MediaQuery.of(context).size.width * 0.16, // Adjust this value as needed
            right: MediaQuery.of(context).size.width * 0.16,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: [Colors.yellow, Colors.lightGreenAccent.shade100], // Adjust gradient colors as needed
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: AnimatedOpacity(
                duration: Duration(seconds: 3),
                opacity: _opacity,
                child: Text(
                  'Gas Leakage',
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      color: Colors.white, // Text color will be overridden by the shader
                      fontSize: 34.0,
                      fontWeight: FontWeight.bold,
                    )
                    // fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ),
          ),

          // Positioned(
          //   // Adjust the position as needed
          //   top: 0,
          //   bottom: 100,
          //   left: 0,
          //   right: 140,
          //   child: Image.asset("assets/images/gas.gif"), // Replace this with your GIF asset
          // ),
        ],
      ),
    );
  }
}
