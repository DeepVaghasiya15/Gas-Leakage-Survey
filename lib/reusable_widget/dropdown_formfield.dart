import 'package:flutter/material.dart';

class CustomDropdownWidget extends StatelessWidget {
  final String hintText;
  final List<String> items;
  final String? selectedValue;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;
  final String? Function(String?)? onSaved;

  const CustomDropdownWidget({
    Key? key,
    required this.hintText,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.validator,
    this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF31363F)),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Color(0xFF76ABAE),
              width: 2.0
          ), // Set your custom color here
          borderRadius: BorderRadius.circular(15),
        ),
        hintText: hintText,
      ),
      hint: selectedValue == null
          ? Text(
        hintText,
        style: TextStyle(
            fontSize: 14,
            color: Colors.grey
        ),
      )
          : null,
      value: selectedValue,
      items: items
          .map((item) => DropdownMenuItem<String>(
        value: item,
        child: Text(
          item,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ))
          .toList(),
      validator: validator,
      onChanged: onChanged,
      onSaved: onSaved,
    );
  }
}
