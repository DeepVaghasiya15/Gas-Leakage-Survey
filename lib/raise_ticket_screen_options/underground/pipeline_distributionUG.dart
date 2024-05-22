import 'package:flutter/material.dart';
import 'package:gas_leakage_survey/data/raise_ticket_data.dart';
import 'package:gas_leakage_survey/raise_ticket_screen_options/underground/diameter_of_pipelineUGBranch.dart';
import 'package:gas_leakage_survey/raise_ticket_screen_options/underground/diameter_of_pipelineUGDistribution.dart';
import 'package:gas_leakage_survey/raise_ticket_screen_options/underground/diameter_of_pipelineUGMains.dart';
import 'package:gas_leakage_survey/raise_ticket_screen_options/underground/diameter_of_pipelineUGService.dart';
import 'package:flutter/services.dart';
import '../../screens/raise_ticket_screen_options.dart';

class PipelineDistributionUG extends StatelessWidget {
  const PipelineDistributionUG({Key? key}) : super(key: key);

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
      padding: const EdgeInsets.only(top:50.0,right: 20,left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            DataFields[5],
            style: const TextStyle(fontSize: 37, fontWeight: FontWeight.bold,color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50),
          GridView.count(
            crossAxisCount: 2, // 2 columns
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: pipelineDistributionUG.asMap().entries.map((entry) {
              int index = entry.key;
              String type = entry.value;
              String iconPath = pipelineDistributionUGIcon[index];

              return Padding(
                padding: const EdgeInsets.all(6.0),
                child: MaterialButton(
                  onPressed: () {
                    HapticFeedback.vibrate();
                    // Add your onPressed functionality here
                    print('Button pressed: $type');
                    selectedOptionArray.add('$type');
                    print(selectedOptionArray);

                    if (type == 'Service') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DiameterOfPipelineUGService()),
                      );
                    } else if (type == 'Distribution') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DiameterOfPipelineUGDistribution()),
                      );
                      // Navigate to Commercial screen
                    } else if (type == 'Branch') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DiameterOfPipelineUGBranch()),
                      );
                      // Navigate to Industrial screen
                    } else if (type == 'Mains') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DiameterOfPipelineUGMains()),
                      );
                      // Navigate to Open Area screen
                    }

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
                        iconPath,
                        height: 40,
                      ),
                      const SizedBox(height: 5), // Add some space between icon and text
                      Text(
                        type,
                        style: const TextStyle(fontSize: 17, color: Colors.black),
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
