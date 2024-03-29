import 'package:flutter/material.dart';

class RaiseTicket extends StatefulWidget {
  const RaiseTicket({super.key});

  @override
  State<RaiseTicket> createState() => _RaiseTicketState();
}

class _RaiseTicketState extends State<RaiseTicket> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(
        'Raise Ticket',
        style: TextStyle(color: Colors.white),
      ),
        backgroundColor: Color(0xFF31363F),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white, // Change the color of the back button to white
        ),
      ),
    );
  }
}
