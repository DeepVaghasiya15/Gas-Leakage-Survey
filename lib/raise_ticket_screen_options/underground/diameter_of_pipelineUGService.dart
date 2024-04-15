import 'package:flutter/material.dart';
import 'package:gas_leakage_survey/data/raise_ticket_data.dart';
import 'package:gas_leakage_survey/raise_ticket_screen_options/underground/source_of_leakUG.dart';

class DiameterOfPipelineUGService extends StatelessWidget {
  const DiameterOfPipelineUGService({Key? key}) : super(key: key);


@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Raise Ticket"),
      backgroundColor: Color(0xFFFFC604),
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
            crossAxisCount: 3, // 2 columns
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: List.generate(
              // Generate a list of pairs of texts and arrays
              diameterOfPipelineUGService.length,
                  (index) {
                String type = diameterOfPipelineUGServiceNumber[index];
                String otherArray = diameterOfPipelineUGService[index]; // Assuming you have another array to pair with each text

                return Padding(
                  padding: EdgeInsets.all(6.0),
                  child: MaterialButton(
                    onPressed: () {
                      // Add your onPressed functionality here
                      print('Button pressed: $type');
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SourceOfLeakUG()));
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
