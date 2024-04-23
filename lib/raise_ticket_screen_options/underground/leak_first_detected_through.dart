import 'package:flutter/material.dart';
import 'package:gas_leakage_survey/data/raise_ticket_data.dart';
import 'package:gas_leakage_survey/raise_ticket_screen_options/aboveground/pipelineAG.dart';
import 'package:gas_leakage_survey/raise_ticket_screen_options/underground/pipelineUG.dart';
import 'package:flutter/services.dart';
import '../../screens/raise_ticket_screen_options.dart';

class LeakFirstDetectedThrough extends StatelessWidget {
  const LeakFirstDetectedThrough({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Color(0xFF292C3D),
    appBar: AppBar(
      title: Text("Raise Ticket"),
      backgroundColor: Color(0xFFEFFF00),
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
            DataFields[2],
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold,color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 70),
          GridView.count(
            crossAxisCount: 2, // 2 columns
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: leakFirstDetectedThrough.asMap().entries.map((entry) {
              int index = entry.key;
              String type = entry.value;
              String iconPath = leakFirstDetectedThroughIcon[index]; // Get corresponding icon path

              return Padding(
                padding: EdgeInsets.all(6.0),
                child: MaterialButton(
                  onPressed: () {
                    HapticFeedback.vibrate();
                    // Add your onPressed functionality here
                    print('Button pressed: $type');

                    selectedOptionArray.add('$type');
                    print(selectedOptionArray);

                    if (selectedOption == 'Underground') {
                      print('Underground selected');
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PipelineUG()));
                    } else if (selectedOption == 'Above Ground') {
                      print('Above Ground selected');
                      // Navigate to the corresponding screen for 'Above Ground'
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PipelineAG()));
                    }
                  },
                  color: Color(0xFFEFFF00),
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
