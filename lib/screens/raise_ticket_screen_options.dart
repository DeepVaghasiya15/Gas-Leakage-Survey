import 'dart:convert';
import 'package:gas_leakage_survey/reusable_widget/switch_screen.dart';
import 'package:gas_leakage_survey/screens/raise_ticket_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:gas_leakage_survey/data/raise_ticket_data.dart';
import 'package:gas_leakage_survey/raise_ticket_screen_options/underground/consumer_type.dart';

String? selectedOption;
List<String> selectedOptionArray = [];
// class RaiseTicketScreenOptions extends StatefulWidget {
//   const RaiseTicketScreenOptions({Key? key}) : super(key: key);
//
//   @override
//   State<RaiseTicketScreenOptions> createState() => _RaiseTicketScreenOptionsState();
// }
class RaiseTicketScreenOptions extends StatefulWidget {
  final bool isSurveyInProgress;

  const RaiseTicketScreenOptions({Key? key, required this.isSurveyInProgress})
      : super(key: key);

  @override
  State<RaiseTicketScreenOptions> createState() =>
      _RaiseTicketScreenOptionsState();
}

class _RaiseTicketScreenOptionsState extends State<RaiseTicketScreenOptions> {
  @override
  Widget build(BuildContext context) {
    Future<void> createTicket(String selectedOption) async {
      try {
        final response = await http.post(
          Uri.parse('https://picarro-backend.onrender.com/tickets/create'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'type_of_Leak': selectedOption,
          }),
        );

        if (response.statusCode == 200) {
          // If the server returns a 200 OK response, it means the ticket was created successfully.
          print('Ticket created successfully');
          // Optionally, you can navigate to the next screen or perform any other action here.
        } else {
          // If the server returns an error response, print the response body for debugging.
          print('Failed to create ticket. Server returned: ${response.body}');
          // Optionally, you can show an error message to the user.
        }
      } catch (e) {
        // If an exception occurs during the HTTP request, print the error for debugging.
        print('Error creating ticket: $e');
        // Optionally, you can show an error message to the user.
      }
    }

    return Scaffold(
      appBar: AppBar(
          title: Text("Raise Ticket"),
          backgroundColor: Color(
            0xFFFFC604),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (selectedOptionArray.isNotEmpty) {
              // Remove the last item from selectedOptionArray
              selectedOptionArray.removeLast();
              print(selectedOptionArray);
            }
            // Pop the current route from the navigation stack
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.splitscreen), // You can use any icon here
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RaiseTicket()),
              );
            },
          ),
        ],
          ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 80, horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset("assets/images/type_of_leak_bg.png"),
                    SizedBox(
                      height: 40,
                    ),
                    Text(DataFields[0],
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 140, // Set the width of the buttons
                          height: 130, // Set the height of the buttons
                          child: MaterialButton(
                            onPressed: () {
                              setState(() {
                                selectedOption = 'Underground';
                                selectedOptionArray.add(selectedOption!);
                              });
                              createTicket(selectedOption!);
                              print('selected option is : $selectedOption');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ConsumerType()));
                            },
                            color: Color(0xFFFFC604),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation:
                                10, // Adjust the elevation to create a 3D effect
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/UnderGroundIcon.png',
                                  width: 30,
                                  height: 30,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Underground',
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        SizedBox(
                          width: 145, // Set the width of the buttons
                          height: 130, // Set the height of the buttons
                          child: MaterialButton(
                            onPressed: () {
                              setState(() {
                                selectedOption = 'Above Ground';
                                selectedOptionArray.add(selectedOption!);
                              });
                              createTicket(selectedOption!);
                              print('selected option is : $selectedOption');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ConsumerType()));
                            },
                            color: Color(0xFFFFC604),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation:
                                10, // Adjust the elevation to create a 3D effect
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/AboveGroundIcon.png',
                                  width: 30,
                                  height: 30,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Above Ground',
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
