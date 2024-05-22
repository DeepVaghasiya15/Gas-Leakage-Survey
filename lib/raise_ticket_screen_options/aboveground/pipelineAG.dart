import 'package:flutter/material.dart';
import 'package:gas_leakage_survey/data/raise_ticket_data.dart';
import 'package:gas_leakage_survey/raise_ticket_screen_options/aboveground/pressure_of_pipelineAG.dart';
import 'package:flutter/services.dart';
import '../../screens/raise_ticket_screen_options.dart';

class PipelineAG extends StatelessWidget {
  const PipelineAG({Key? key}) : super(key: key);

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
      padding: const EdgeInsets.only(top:70.0,right: 80,left: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            DataFields[3],
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold,color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 160),
          GridView.count(
            crossAxisCount: 1,
            shrinkWrap: true,
            // childAspectRatio: 1.5,
            physics: const NeverScrollableScrollPhysics(),
            children: pipelineAG.asMap().entries.map((entry) {
              int index = entry.key;
              String type = entry.value;
              String iconPath = pipelineAGIcon[index];

              return Padding(
                padding: const EdgeInsets.all(6.0),
                child: MaterialButton(
                  onPressed: () {
                    HapticFeedback.vibrate();
                    // Add your onPressed functionality here
                    print('Button pressed: $type');
                    selectedOptionArray.add('$type');
                    print(selectedOptionArray);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PressureOfPipelineAG()));
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
                      const SizedBox(height: 5),
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
