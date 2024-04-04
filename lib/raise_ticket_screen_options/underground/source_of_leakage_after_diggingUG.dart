import 'package:flutter/material.dart';
import 'package:gas_leakage_survey/data/raise_ticket_data.dart';
import 'package:gas_leakage_survey/raise_ticket_screen_options/underground/probable_cause_of_leak_after_diggingUG.dart';

class SourceOfLeakageAfterDiggingUG extends StatelessWidget {
  const SourceOfLeakageAfterDiggingUG({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Raise Ticket")),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      DataFields[10], // Replace with your text or use DataFields[0]
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 40),
                    Column(
                      children: sourceOfLeakageAfterDiggingUG.map((type) {
                        return Column(
                          children: [
                            MaterialButton(
                              onPressed: () {
                                // Add your onPressed functionality here
                                print('Button pressed: $type');
                                // You can navigate or perform any other action here
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ProbableCauseOfLeakAfterDiggingUG()));
                              },
                              color: Color(0xFF76ABAE),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              minWidth: double.infinity,
                              height: 50,
                              child: Text(
                                type,
                                style: TextStyle(fontSize: 17, color: Colors.black),
                              ),
                            ),
                            SizedBox(height: 10),
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
