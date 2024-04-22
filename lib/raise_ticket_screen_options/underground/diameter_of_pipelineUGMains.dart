import 'package:flutter/material.dart';
import 'package:gas_leakage_survey/data/raise_ticket_data.dart';
import 'package:gas_leakage_survey/raise_ticket_screen_options/underground/source_of_leakUG.dart';

import '../../screens/raise_ticket_screen_options.dart';
import 'location_of_pipeUG.dart';

class DiameterOfPipelineUGMains extends StatelessWidget {
  const DiameterOfPipelineUGMains({Key? key}) : super(key: key);

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
      padding: const EdgeInsets.only(top: 60.0, right: 20, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            DataFields[6],
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 190),
          GridView.count(
            crossAxisCount: 2, // 2 columns
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: List.generate(
              // Generate a list of pairs of texts and arrays
              diameterOfPipelineUGMains.length,
                  (index) {
                String type = diameterOfPipelineUGMainsNumber[index];
                String otherArray = diameterOfPipelineUGMains[
                index]; // Assuming you have another array to pair with each text

                return Padding(
                  padding: EdgeInsets.all(6.0),
                  child: MaterialButton(
                    onPressed: () {
                      // Add your onPressed functionality here
                      print('Button pressed: $type');
                      selectedOptionArray.add('$type mm');
                      print(selectedOptionArray);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LocationOfPipeUG()));
                    },
                    color: Color(0xFFFFC604),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 10,
                    minWidth: double.infinity,
                    height: 100,
                    // Increased height to accommodate the icon
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          type,
                          style: TextStyle(fontSize: 40, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 1),
                        Text(
                          otherArray,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
}
