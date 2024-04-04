import 'package:flutter/material.dart';
import 'package:gas_leakage_survey/data/raise_ticket_data.dart';
import 'package:gas_leakage_survey/raise_ticket_screen_options/underground/consumer_type.dart';

String? selectedOption;

class RaiseTicketScreenOptions extends StatefulWidget {
  const RaiseTicketScreenOptions({Key? key}) : super(key: key);

  @override
  State<RaiseTicketScreenOptions> createState() => _RaiseTicketScreenOptionsState();
}
class _RaiseTicketScreenOptionsState extends State<RaiseTicketScreenOptions> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Raise Ticket")),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 190, horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(DataFields[0], style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                    SizedBox(height: 40),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          selectedOption = 'Underground';
                        });
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ConsumerType()));
                      },
                      color: Color(0xFF76ABAE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minWidth: double.infinity,
                      height: 50,
                      child: const Text(
                        'Underground',
                        style: TextStyle(fontSize: 17, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 10),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          selectedOption = 'Above Ground';
                        });
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ConsumerType()));
                      },
                      color: Color(0xFF76ABAE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minWidth: double.infinity,
                      height: 50,
                      child: const Text(
                        'Above Ground',
                        style: TextStyle(fontSize: 17, color: Colors.black),
                      ),
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
