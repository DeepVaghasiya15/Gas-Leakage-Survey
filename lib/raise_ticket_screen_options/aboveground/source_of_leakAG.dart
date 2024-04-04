import 'package:flutter/material.dart';
import 'package:gas_leakage_survey/data/raise_ticket_data.dart';
import 'package:gas_leakage_survey/raise_ticket_screen_options/aboveground/probable_cause_of_leak_after_diggingAG.dart';

class SourceOfLeakAG extends StatelessWidget {
  const SourceOfLeakAG({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Raise Ticket")),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      DataFields[7], // Replace with your text or use DataFields[0]
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: sourceOfLeakAG.map((type) {
                        return Column(
                          children: [
                            MaterialButton(
                              onPressed: () {
                                // Add your onPressed functionality here
                                print('Button pressed: $type');
                                // You can navigate or perform any other action here
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ProbableCauseOfLeakAfterDiggingAG()));
                              },
                              color: Color(0xFF76ABAE),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              minWidth: double.infinity,
                              height: 40,
                              child: Text(
                                type,
                                style: TextStyle(fontSize: 17, color: Colors.black),
                              ),
                            ),
                            SizedBox(height: 1),
                          ],
                        );
                      }).toList(),
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
