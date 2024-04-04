import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormFill extends StatefulWidget {
  const FormFill({super.key});

  @override
  State<FormFill> createState() => _FormFillState();
}

class _FormFillState extends State<FormFill> {
  bool isLoading = false;
  bool isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Raise Ticket")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 115, horizontal: 20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Fill this details..", // Replace with your text or use DataFields[0]
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 40,),
              TextField(
                cursorColor: Color(0xFF31363F),
                decoration: InputDecoration(
                  labelText: 'Main Area',
                  labelStyle: TextStyle(color: Colors.grey,),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFF76ABAE),
                        width: 2.0), // Set your custom color here
                    borderRadius: BorderRadius.circular(15),
                  ),
                  // contentPadding: EdgeInsets.symmetric(vertical: 10)
                ),
              ),
              const SizedBox(
                height: 10,
              ),
        
              //Sub Area / Location
              TextField(
                cursorColor: Color(0xFF31363F),
                decoration: InputDecoration(
                  labelText: 'Sub Area / Location',
                  labelStyle: TextStyle(color: Colors.grey,),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFF76ABAE),
                        width: 2.0), // Set your custom color here
                    borderRadius: BorderRadius.circular(15),
                  ),
                  // contentPadding: EdgeInsets.symmetric(vertical: 10)
                ),
              ),
              const SizedBox(
                height: 10,
              ),
        
              //DP-IR Reading when leak detected first
              TextField(
                cursorColor: Color(0xFF31363F),
                decoration: InputDecoration(
                  labelText: 'DP-IR Reading when leak detected first',
                  labelStyle: TextStyle(color: Colors.grey,),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFF76ABAE),
                        width: 2.0), // Set your custom color here
                    borderRadius: BorderRadius.circular(15),
                  ),
                  // contentPadding: EdgeInsets.symmetric(vertical: 10)
                ),
              ),
              const SizedBox(
                height: 10,
              ),
        
              //DP-IR Reading using Bar Hole probe
              TextField(
                cursorColor: Color(0xFF31363F),
                decoration: InputDecoration(
                  labelText: 'DP-IR Reading using Bar Hole probe',
                  labelStyle: TextStyle(color: Colors.grey,),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFF76ABAE),
                        width: 2.0), // Set your custom color here
                    borderRadius: BorderRadius.circular(15),
                  ),
                  // contentPadding: EdgeInsets.symmetric(vertical: 10)
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (isLoading) return;

                  setState(() => isLoading = true);
                  await Future.delayed(Duration(seconds: 3));
                  setState(() {
                    isLoading = false;
                    isSubmitted = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(fontSize: 24),
                  minimumSize: Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  backgroundColor: Color(0xFF76ABAE), // Change button color here
                ),
                child: isLoading
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.black),
                    SizedBox(width: 20),
                    Text('Please wait...',style: TextStyle(color: Color(0xFF222831)),),
                  ],
                )
                    : isSubmitted
                    ? Text(
                  'Submitted',
                  style: TextStyle(color: Color(0xFF222831)),
                )
                    : Text(
                  'Submit',
                  style: TextStyle(color: Color(0xFF222831)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
