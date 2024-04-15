import 'package:flutter/material.dart';
import 'package:gas_leakage_survey/screens/raise_ticket_screen.dart';

class SwitchScreen extends StatefulWidget {
  final bool initialSwitchValue;
  final ValueChanged<bool> onSwitchChanged;

  const SwitchScreen({
    Key? key,
    required this.initialSwitchValue,
    required this.onSwitchChanged,
  }) : super(key: key);

  @override
  _SwitchScreenState createState() => _SwitchScreenState();
}

class _SwitchScreenState extends State<SwitchScreen> {
  late bool _isSwitched;

  @override
  void initState() {
    super.initState();
    _isSwitched = widget.initialSwitchValue;
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: _isSwitched,
      onChanged: (value) {
        setState(() {
          _isSwitched = value;
          widget.onSwitchChanged(value); // Notify the parent widget about switch state change
        });
      },
    );
  }
}
