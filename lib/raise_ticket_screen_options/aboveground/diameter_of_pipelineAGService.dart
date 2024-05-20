import 'package:flutter/material.dart';
import 'package:gas_leakage_survey/data/raise_ticket_data.dart';
import 'package:gas_leakage_survey/raise_ticket_screen_options/aboveground/source_of_leakAG.dart';
import 'package:flutter/services.dart';
import '../../screens/raise_ticket_screen_options.dart';
import '../underground/source_of_leakUG.dart';

class DiameterOfPipelineAGService extends StatelessWidget {
  const DiameterOfPipelineAGService({Key? key}) : super(key: key);


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
      padding: const EdgeInsets.only(top: 60.0, right: 20, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            DataFields[6],
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold,color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 70),
          GridView.count(
            crossAxisCount: 2, // 2 columns
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(
              // Generate a list of pairs of texts and arrays
              diameterOfPipelineAGService.length,
                  (index) {
                String type = diameterOfPipelineAGServiceNumber[index];
                String otherArray = diameterOfPipelineAGService[
                index]; // Assuming you have another array to pair with each text

                return Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: MaterialButton(
                    onPressed: () {
                      HapticFeedback.vibrate();
                      // Add your onPressed functionality here
                      print('Button pressed: $type');
                      selectedOptionArray.add('$type mm');
                      print(selectedOptionArray);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SourceOfLeakAG()));
                    },
                    color: Color(0xFFEFFF00),
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

