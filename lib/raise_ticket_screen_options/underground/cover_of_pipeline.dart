import 'package:flutter/material.dart';
import 'package:gas_leakage_survey/data/raise_ticket_data.dart';
import 'package:gas_leakage_survey/raise_ticket_screen_options/underground/leak_grading.dart';
import 'package:gas_leakage_survey/raise_ticket_screen_options/underground/source_of_leakage_after_diggingUG.dart';
import 'package:flutter/services.dart';
import '../../screens/raise_ticket_screen_options.dart';
import '../aboveground/source_of_leakage_afterDiggingAG.dart';

class CoverOfPipeline extends StatelessWidget {
  const CoverOfPipeline({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF292C3D),
    appBar: AppBar(
      title: const Text("Raise Ticket"),
      backgroundColor: const Color(0xFFEFFF00),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
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
      padding: const EdgeInsets.only(top:17.0,right: 20,left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            DataFields[9],
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold,color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2, // 2 columns
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: coverOfPipeline.asMap().entries.map((entry) {
              int index = entry.key;
              String type = entry.value;
              String iconPath = coverOfPipelineIcon[index];

              return Padding(
                padding: const EdgeInsets.all(7.0),
                child: MaterialButton(
                  onPressed: () {
                    HapticFeedback.vibrate();
                    print('Button pressed: $type');
                    selectedOptionArray.add('$type');
                    print(selectedOptionArray);
                    // if (selectedOption == 'Underground') {
                    //   print('Underground selected');
                    //   Navigator.push(context, MaterialPageRoute(builder: (context) => SourceOfLeakageAfterDiggingUG()));
                    // } else if (selectedOption == 'Above Ground') {
                    //   print('Above Ground selected');
                    //   // Navigate to the corresponding screen for 'Above Ground'
                    //   Navigator.push(context, MaterialPageRoute(builder: (context) => SourceOfLeakageAfterDiggingAG()));
                    // }
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LeakGrading()));
                  },
                  color: const Color(0xFFEFFF00),
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
                      const SizedBox(height: 5), // Add some space between icon and text
                      Text(
                        type,
                        style: const TextStyle(fontSize: 17, color: Colors.black),
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
