import 'package:flutter/material.dart';
import 'package:gas_leakage_survey/data/raise_ticket_data.dart';
import 'package:gas_leakage_survey/raise_ticket_screen_options/aboveground/pipeline_distributionAG.dart';
import 'package:flutter/services.dart';
import '../../screens/raise_ticket_screen_options.dart';

class PressureOfPipelineAG extends StatelessWidget {
  const PressureOfPipelineAG({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final screenSize = MediaQuery.of(context).size;
    final double buttonHeight = screenSize.height * 0.15;
    final double buttonWidth = screenSize.width * 0.28;

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
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DataFields[4],
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: screenSize.width > 600 ? 5 : 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: buttonWidth / buttonHeight,
                ),
                itemCount: pressureOfPipelineAG.length,
                itemBuilder: (context, index) {
                  String type = pressureOfPipelineAGNumber[index];
                  String otherArray = pressureOfPipelineAG[index];
                  Color buttonColor = index == 0 ? Colors.red : const Color(0xFFEFFF00);
                  bool mBar = type == "110" || type == "21";

                  return MaterialButton(
                    onPressed: () {
                      HapticFeedback.vibrate();
                      // Add your onPressed functionality here
                      print('Button pressed: $type');
                      if (mBar) {
                        selectedOptionArray.add('$type m Bar');
                      } else {
                        selectedOptionArray.add('$type Bar');
                      }
                      print(selectedOptionArray);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PipelineDistributionAG()),
                      );
                    },
                    color: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 10,
                    minWidth: double.infinity,
                    height: buttonHeight,
                    // Increased height to accommodate the icon
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          type,
                          style: TextStyle(fontSize: type == '110' ? 28 : 35, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          otherArray,
                          style: const TextStyle(fontSize: 16, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ],
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
