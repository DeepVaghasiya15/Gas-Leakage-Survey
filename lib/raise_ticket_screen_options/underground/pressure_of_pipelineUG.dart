import 'package:flutter/material.dart';
import 'package:gas_leakage_survey/data/raise_ticket_data.dart';
import 'package:gas_leakage_survey/raise_ticket_screen_options/underground/pipelineUG.dart';
import 'package:gas_leakage_survey/raise_ticket_screen_options/underground/pipeline_distributionUG.dart';
import 'package:flutter/services.dart';
import '../../screens/raise_ticket_screen_options.dart';

class PressureOfPipelineUG extends StatelessWidget {
  const PressureOfPipelineUG({Key? key}) : super(key: key);

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
      padding: const EdgeInsets.only(top: 40.0, right: 20, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            DataFields[4],
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold,color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 100),
          GridView.count(
            crossAxisCount: 3, // 2 columns
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: List.generate(
              // Generate a list of pairs of texts and arrays
              pressureOfPipelineUG.length,
                  (index) {
                String type = pressureOfPipelineUGNumber[index];
                String otherArray = pressureOfPipelineUG[index];
                Color buttonColor = index == 0 ? Colors.red : Color(0xFFEFFF00);
                bool is110 = type == "110";

                return Padding(
                  padding: EdgeInsets.all(6.0),
                  child: MaterialButton(
                    onPressed: () {
                      HapticFeedback.vibrate();
                      // Add your onPressed functionality here
                      print('Button pressed: $type');
                      // selectedOptionArray.add('$type Bar');
                      if (is110) {
                        selectedOptionArray.add('$type m Bar');
                      } else {
                        selectedOptionArray.add('$type Bar');
                      }
                      print(selectedOptionArray);

                      Navigator.push(context, MaterialPageRoute(builder: (context) => PipelineDistributionUG()));
                    },
                    color: buttonColor,
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
                          style: TextStyle(fontSize: 35, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 1),
                        Text(
                          otherArray,
                          style: TextStyle(fontSize: 17, color: Colors.black),
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