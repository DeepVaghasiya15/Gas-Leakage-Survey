import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../data/raise_ticket_conditions.dart';
import '../data/raise_ticket_data.dart';

class RaiseTicket extends StatefulWidget {
  const RaiseTicket({super.key});

  @override
  State<RaiseTicket> createState() => _RaiseTicketState();
}

class _RaiseTicketState extends State<RaiseTicket> {

  bool isLoading = false;
  bool isSubmitted = false;
  List<bool> isExpandedList = [false,false,false];

  String? _selectedTypeOfLeak;
  String? _selectedConsumerType;
  String? _selectedLeakFirstDetectedThrough;
  String? _selectedPipeline;
  String? _selectedPressureOfPipeline;
  String? _selectedPipelineDistributionType;
  String? _selectedDiameterOfPipeline;
  String? _selectedSourceOfLeak;
  String? _selectedLocationOfPipe;
  String? _selectedCoverOfPipeline;
  String? _selectedSourceOfLeakageAfterDigging;
  String? _selectedProbableCauseOfLeakAfterDigging;
  String? _selectedLeakGrading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF31363F),
      appBar: AppBar(
        title: Text(
          'Raise Ticket',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF31363F),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  //Type of leak
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DataFields[0],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF76ABAE)),
                    ),
                  ),
                  const SizedBox(height: 5),
                  DropdownButtonFormField2<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF31363F),
                        width: 6.0),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(0xFF76ABAE),
                            width: 4.0), // Set your custom color here
                        borderRadius: BorderRadius.circular(15),
                      ),
                      // Add more decoration..
                    ),
                    hint: _selectedTypeOfLeak == null
                        ? Text(
                            DataFields[0],
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          )
                        : null,
                    value: _selectedTypeOfLeak,
                    items: typeOfLeak
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
                    validator: (value) {
                      if (value == null) {
                        return 'Please select $DataFields[0].';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _selectedTypeOfLeak = value;
                        _selectedConsumerType = null;
                        isExpandedList[1] = true;

                        if (value == "Underground" || value == "Above Ground") {
                          _selectedPipeline = null;
                          _selectedPressureOfPipeline = null;
                          _selectedPipelineDistributionType = null;
                          _selectedDiameterOfPipeline = null;
                          _selectedSourceOfLeak = null;
                          _selectedLocationOfPipe = null;
                          _selectedCoverOfPipeline = null;
                          _selectedSourceOfLeakageAfterDigging = null;
                          _selectedProbableCauseOfLeakAfterDigging = null;
                          _selectedLeakGrading = null;
                        }
                      });
                    },
                    onSaved: (value) {
                      setState(() {
                        _selectedTypeOfLeak = value;

                      });
                    },
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.only(right: 8),
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 24,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  //Consumer Type
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DataFields[1],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF76ABAE)),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  DropdownButtonFormField2<String>(
                    isExpanded: isExpandedList[1],
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF31363F)),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(0xFF76ABAE),
                            width: 2.0), // Set your custom color here
                        borderRadius: BorderRadius.circular(15),
                      ),
                      // Add more decoration..
                    ),
                    hint: _selectedConsumerType == null
                        ? Text(
                            DataFields[1],
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          )
                        : null,
                    value: _selectedConsumerType,
                    items: consumerType
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
                    validator: (value) {
                      if (value == null) {
                        return 'Please select gender.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _selectedConsumerType = value;
                        _selectedLeakFirstDetectedThrough = null;
                        isExpandedList[2] = true;
                      });
                      //Do something when selected item is changed.
                    },
                    onSaved: (value) {
                      setState(() {
                        _selectedConsumerType = value;
                      });
                    },
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.only(right: 8),
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 24,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  //Leak first detected through
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DataFields[2],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF76ABAE)),
                    ),
                  ),
                  const SizedBox(height: 5),
                  DropdownButtonFormField2<String>(
                    isExpanded: isExpandedList[2],
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF31363F)),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(0xFF76ABAE),
                            width: 2.0), // Set your custom color here
                        borderRadius: BorderRadius.circular(15),
                      ),
                      // Add more decoration..
                    ),
                    hint: _selectedLeakFirstDetectedThrough == null
                        ? Text(
                            DataFields[2],
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          )
                        : null,
                    value: _selectedLeakFirstDetectedThrough,
                    items: leakFirstDetectedThrough
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
                    validator: (value) {
                      if (value == null) {
                        return 'Please select gender.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _selectedLeakFirstDetectedThrough = value;
                      });
                      //Do something when selected item is changed.
                    },
                    onSaved: (value) {
                      setState(() {
                        _selectedLeakFirstDetectedThrough = value;
                      });
                    },
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.only(right: 8),
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 24,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  //Pipeline
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DataFields[3],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF76ABAE)),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  DropdownButtonFormField2<String>(
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
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      // Add more decoration..
                    ),
                    hint: _selectedPipeline == null
                        ? Text(
                            DataFields[3],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          )
                        : null,
                    value: _selectedPipeline,
                    items: _selectedTypeOfLeak != null
                        ? generateItemsBasedOnTypeOfLeakPipeline(_selectedTypeOfLeak!)
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                            .toList()
                        : [],
                    validator: (value) {
                      if (value == null) {
                        return 'Please select gender.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _selectedPipeline = value;
                      });
                      //Do something when selected item is changed.
                    },
                    onSaved: (value) {
                      setState(() {
                        _selectedPipeline = value;
                      });
                    },
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.only(right: 8),
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 24,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),

                  //Pressure of pipeline
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DataFields[4],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF76ABAE)),
                    ),
                  ),
                  const SizedBox(height: 5),
                  DropdownButtonFormField2<String>(
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
                            width: 2.0), // Set your custom color here
                        borderRadius: BorderRadius.circular(15),
                      ),
                      // Add more decoration..
                    ),
                    hint: _selectedPressureOfPipeline == null
                        ? Text(
                            DataFields[4],
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          )
                        : null,
                    value: _selectedPressureOfPipeline,
                    items: _selectedTypeOfLeak != null
                        ? generateItemsBasedOnPressureOfPipeline(_selectedTypeOfLeak!)
                        .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ))
                        .toList()
                        : [],
                    validator: (value) {
                      if (value == null) {
                        return 'Please select gender.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _selectedPressureOfPipeline = value;
                      });
                      //Do something when selected item is changed.
                    },
                    onSaved: (value) {
                      setState(() {
                        _selectedPressureOfPipeline = value;
                      });
                    },
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.only(right: 8),
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 24,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  //Pipeline distribution type
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DataFields[5],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF76ABAE)),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  DropdownButtonFormField2<String>(
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
                            width: 2.0), // Set your custom color here
                        borderRadius: BorderRadius.circular(15),
                      ),
                      // Add more decoration..
                    ),
                    hint: _selectedPipelineDistributionType == null
                        ? Text(
                            DataFields[5],
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          )
                        : null,
                    value: _selectedPipelineDistributionType,
                    items: _selectedTypeOfLeak != null
                        ? generateItemsBasedOnPipelineDistribution(_selectedTypeOfLeak!)
                        .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ))
                        .toList()
                        : [],
                    validator: (value) {
                      if (value == null) {
                        return 'Please select gender.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _selectedPipelineDistributionType = value;

                        if (value == "Service" || value == "Distribution" || value == "Branch" || value == "Mains") {
                          _selectedDiameterOfPipeline = null;
                        }
                      });
                      //Do something when selected item is changed.
                    },
                    onSaved: (value) {
                      setState(() {
                        _selectedPipelineDistributionType = value;
                      });
                    },
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.only(right: 8),
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 24,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  //Diameter of Pipeline
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DataFields[6],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF76ABAE)),
                    ),
                  ),
                  const SizedBox(height: 5),
                  DropdownButtonFormField2<String>(
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
                            width: 2.0), // Set your custom color here
                        borderRadius: BorderRadius.circular(15),
                      ),
                      // Add more decoration..
                    ),
                    hint: _selectedDiameterOfPipeline == null
                        ? Text(
                            DataFields[6],
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          )
                        : null,
                    value: _selectedDiameterOfPipeline,
                    items: _selectedPipelineDistributionType != null
                        ? generateItemsBasedOnPipelineDistributionType(_selectedPipelineDistributionType!,_selectedTypeOfLeak!)
                        .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ))
                        .toList()
                        : [],
                    validator: (value) {
                      if (value == null) {
                        return 'Please select gender.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _selectedDiameterOfPipeline = value;
                      });
                      //Do something when selected item is changed.
                    },
                    onSaved: (value) {
                      setState(() {
                        _selectedDiameterOfPipeline = value;
                      });
                    },
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.only(right: 8),
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 24,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  //Source of leak
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DataFields[7],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF76ABAE)),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  DropdownButtonFormField2<String>(
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
                            width: 2.0), // Set your custom color here
                        borderRadius: BorderRadius.circular(15),
                      ),
                      // Add more decoration..
                    ),
                    hint: _selectedSourceOfLeak == null
                        ? Text(
                            DataFields[7],
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          )
                        : null,
                    value: _selectedSourceOfLeak,
                    items: _selectedTypeOfLeak != null
                        ? generateItemsBasedOnSourceOfLeak(_selectedTypeOfLeak!)
                        .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ))
                        .toList()
                        : [],
                    validator: (value) {
                      if (value == null) {
                        return 'Please select gender.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _selectedSourceOfLeak = value;
                      });
                      //Do something when selected item is changed.
                    },
                    onSaved: (value) {
                      setState(() {
                        _selectedSourceOfLeak = value;
                      });
                    },
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.only(right: 8),
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 24,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  //Location of Pipe
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DataFields[8],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF76ABAE)),
                    ),
                  ),
                  const SizedBox(height: 5),
                  DropdownButtonFormField2<String>(
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
                            width: 2.0), // Set your custom color here
                        borderRadius: BorderRadius.circular(15),
                      ),
                      // Add more decoration..
                    ),
                    hint: _selectedLocationOfPipe == null
                        ? Text(
                            DataFields[8],
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          )
                        : null,
                    value: _selectedLocationOfPipe,
                    items: _selectedTypeOfLeak != null
                        ? generateItemsBasedOnLocationOfPipe(_selectedTypeOfLeak!)
                        .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ))
                        .toList()
                        : [],
                    validator: (value) {
                      if (value == null) {
                        return 'Please select gender.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _selectedLocationOfPipe = value;
                      });
                      //Do something when selected item is changed.
                    },
                    onSaved: (value) {
                      setState(() {
                        _selectedLocationOfPipe = value;
                      });
                    },
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.only(right: 8),
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 24,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  //Cover of Pipeline
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DataFields[9],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF76ABAE)),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  DropdownButtonFormField2<String>(
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
                            width: 2.0), // Set your custom color here
                        borderRadius: BorderRadius.circular(15),
                      ),
                      // Add more decoration..
                    ),
                    hint: _selectedCoverOfPipeline == null
                        ? Text(
                            DataFields[9],
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          )
                        : null,
                    value: _selectedCoverOfPipeline,
                    items: coverOfPipeline
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
                    validator: (value) {
                      if (value == null) {
                        return 'Please select gender.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _selectedCoverOfPipeline = value;
                      });
                      //Do something when selected item is changed.
                    },
                    onSaved: (value) {
                      setState(() {
                        _selectedCoverOfPipeline = value;
                      });
                    },
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.only(right: 8),
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 24,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  //Source of Leakage (After Digging)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DataFields[10],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF76ABAE)),
                    ),
                  ),
                  const SizedBox(height: 5),
                  DropdownButtonFormField2<String>(
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
                            width: 2.0), // Set your custom color here
                        borderRadius: BorderRadius.circular(15),
                      ),
                      // Add more decoration..
                    ),
                    hint: _selectedSourceOfLeakageAfterDigging == null
                        ? Text(
                            DataFields[10],
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          )
                        : null,
                    value: _selectedSourceOfLeakageAfterDigging,
                    items: _selectedTypeOfLeak != null
                        ? generateItemsBasedOnSourceOfLeakageAfterDigging(_selectedTypeOfLeak!)
                        .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ))
                        .toList()
                        : [],
                    validator: (value) {
                      if (value == null) {
                        return 'Please select gender.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _selectedSourceOfLeakageAfterDigging = value;
                      });
                      //Do something when selected item is changed.
                    },
                    onSaved: (value) {
                      setState(() {
                        _selectedSourceOfLeakageAfterDigging = value;
                      });
                    },
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.only(right: 8),
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 24,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  //Probable Cause of leak (After Digging)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DataFields[11],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF76ABAE)),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  DropdownButtonFormField2<String>(
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
                            width: 2.0), // Set your custom color here
                        borderRadius: BorderRadius.circular(15),
                      ),
                      // Add more decoration..
                    ),
                    hint: _selectedProbableCauseOfLeakAfterDigging == null
                        ? Text(
                            DataFields[11],
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          )
                        : null,
                    value: _selectedProbableCauseOfLeakAfterDigging,
                    items: _selectedTypeOfLeak != null
                        ? generateItemsBasedOnSourceOfProbableCauseOfLeakAfterDigging(_selectedTypeOfLeak!)
                        .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ))
                        .toList()
                        : [],
                    validator: (value) {
                      if (value == null) {
                        return 'Please select gender.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _selectedProbableCauseOfLeakAfterDigging = value;
                      });
                      //Do something when selected item is changed.
                    },
                    onSaved: (value) {
                      setState(() {
                        _selectedProbableCauseOfLeakAfterDigging = value;
                      });
                    },
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.only(right: 8),
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 24,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  //Leak grading
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DataFields[12],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF76ABAE)),
                    ),
                  ),
                  const SizedBox(height: 5),
                  DropdownButtonFormField2<String>(
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
                            width: 2.0), // Set your custom color here
                        borderRadius: BorderRadius.circular(15),
                      ),
                      // Add more decoration..
                    ),
                    hint: _selectedLeakGrading == null
                        ? Text(
                            DataFields[12],
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          )
                        : null,
                    value: _selectedLeakGrading,
                    items: leakGrading
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
                    validator: (value) {
                      if (value == null) {
                        return 'Please select gender.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _selectedLeakGrading = value;
                      });
                      //Do something when selected item is changed.
                    },
                    onSaved: (value) {
                      setState(() {
                        _selectedLeakGrading = value;
                      });
                    },
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.only(right: 8),
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 24,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(height: 10.0),

                  //Main Area
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
                    height: 20,
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
                      minimumSize: Size.fromHeight(55),
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
        ),
      ),
    );
  }
}
