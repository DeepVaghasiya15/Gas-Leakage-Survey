import 'package:flutter/material.dart';
import 'package:gas_leakage_survey/data/raise_ticket_data.dart';
import 'package:gas_leakage_survey/raise_ticket_screen_options/underground/source_of_leakage_after_diggingUG.dart';

import '../../screens/raise_ticket_screen_options.dart';
import '../aboveground/source_of_leakage_afterDiggingAG.dart';

class CoverOfPipeline extends StatelessWidget {
  const CoverOfPipeline({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Raise Ticket"),
      backgroundColor: Color(0xFFFFC604),
    ),
    body: Padding(
      padding: const EdgeInsets.only(top:50.0,right: 20,left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            DataFields[9],
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          GridView.count(
            crossAxisCount: 2, // 2 columns
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: coverOfPipeline.asMap().entries.map((entry) {
              int index = entry.key;
              String type = entry.value;
              String iconPath = coverOfPipelineIcon[index];

              return Padding(
                padding: EdgeInsets.all(6.0),
                child: MaterialButton(
                  onPressed: () {
                    // Add your onPressed functionality here
                    print('Button pressed: $type');
                    if (selectedOption == 'Underground') {
                      print('Underground selected');
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SourceOfLeakageAfterDiggingUG()));
                    } else if (selectedOption == 'Above Ground') {
                      print('Above Ground selected');
                      // Navigate to the corresponding screen for 'Above Ground'
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SourceOfLeakageAfterDiggingAG()));
                    }
                  },
                  color: Color(0xFFFFC604),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 10,
                  minWidth: double.infinity,
                  height: 100, // Increased height to accommodate the icon
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        iconPath, // Use the icon path from the list
                        height: 40, // Adjust height of the icon as needed
                      ),
                      SizedBox(height: 5), // Add some space between icon and text
                      Text(
                        type,
                        style: TextStyle(fontSize: 17, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ),
  );
}
}
