import 'package:flutter/material.dart';
import 'package:gas_leakage_survey/data/raise_ticket_data.dart';
import 'package:gas_leakage_survey/raise_ticket_screen_options/underground/diameter_of_pipelineUGBranch.dart';
import 'package:gas_leakage_survey/raise_ticket_screen_options/underground/diameter_of_pipelineUGDistribution.dart';
import 'package:gas_leakage_survey/raise_ticket_screen_options/underground/diameter_of_pipelineUGMains.dart';
import 'package:gas_leakage_survey/raise_ticket_screen_options/underground/diameter_of_pipelineUGService.dart';

import '../../screens/raise_ticket_screen_options.dart';

class PipelineDistributionUG extends StatelessWidget {
  const PipelineDistributionUG({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Raise Ticket"),
      backgroundColor: Color(0xFFFFC604),
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
    ),
    body: Padding(
      padding: const EdgeInsets.only(top:100.0,right: 20,left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            DataFields[5],
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 70),
          GridView.count(
            crossAxisCount: 2, // 2 columns
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: pipelineDistributionUG.asMap().entries.map((entry) {
              int index = entry.key;
              String type = entry.value;
              String iconPath = pipelineDistributionUGIcon[index];

              return Padding(
                padding: EdgeInsets.all(6.0),
                child: MaterialButton(
                  onPressed: () {
                    // Add your onPressed functionality here
                    print('Button pressed: $type');
                    selectedOptionArray.add('$type');
                    print(selectedOptionArray);

                    if (type == 'Service') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DiameterOfPipelineUGService()),
                      );
                    } else if (type == 'Distribution') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DiameterOfPipelineUGDistribution()),
                      );
                      // Navigate to Commercial screen
                    } else if (type == 'Branch') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DiameterOfPipelineUGBranch()),
                      );
                      // Navigate to Industrial screen
                    } else if (type == 'Mains') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DiameterOfPipelineUGMains()),
                      );
                      // Navigate to Open Area screen
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
                        iconPath,
                        height: 40,
                      ),
                      SizedBox(height: 5), // Add some space between icon and text
                      Text(
                        type,
                        style: TextStyle(fontSize: 17, color: Colors.black),
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
