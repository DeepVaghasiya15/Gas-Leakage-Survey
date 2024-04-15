import 'package:flutter/material.dart';
import 'package:gas_leakage_survey/data/raise_ticket_data.dart';
import 'package:gas_leakage_survey/raise_ticket_screen_options/underground/pressure_of_pipelineUG.dart';

class PipelineUG extends StatelessWidget {
  const PipelineUG({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Raise Ticket"),
      backgroundColor: Color(0xFFFFC604),
    ),
    body: Padding(
      padding: const EdgeInsets.only(top:100.0,right: 20,left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            DataFields[3],
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 170),
          GridView.count(
            crossAxisCount: 3, // 2 columns
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: pipelineUG.asMap().entries.map((entry) {
              int index = entry.key;
              String type = entry.value;
              String iconPath = pipelineUGIcon[index]; // Get corresponding icon path

              return Padding(
                padding: EdgeInsets.all(6.0),
                child: MaterialButton(
                  onPressed: () {
                    // Add your onPressed functionality here
                    print('Button pressed: $type');
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PressureOfPipelineUG()));
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
