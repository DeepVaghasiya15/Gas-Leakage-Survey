import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../data/raise_ticket_data.dart';
import '../home_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late Future<List<String>> _userListFuture;

  @override
  void initState() {
    super.initState();
    _userListFuture = fetchUserList();
  }

  Future<List<String>> fetchUserList() async {
    final response = await http.get(Uri.parse('$baseUrl$getUserEndPoint'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Check if 'data' exists and is a List<dynamic>
      if (responseData.containsKey('data') && responseData['data'] is List) {
        List<dynamic> userData = responseData['data'];
        List<String> userList = userData.map((user) => user['employee_name'].toString()).toList();
        return userList;
      } else {
        throw Exception('Invalid data format');
      }
    } else {
      throw Exception('Failed to load user list');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF292C3D),
      appBar: AppBar(
        title: const Text(
          "Select User",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFEFFF00),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 12),
        child: FutureBuilder<List<String>>(
          future: _userListFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return UserCard(
                    userName: snapshot.data![index],
                    onTap: () {
                      // Pass selected user name to createBy variable
                      createBy = snapshot.data![index];
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(isSurveyInProgress: false,)));
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final String userName;
  final VoidCallback onTap;

  const UserCard({Key? key, required this.userName, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Execute onTap callback when tapped
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.black12, // Change as per your design
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[200],
              child: Icon(
                Icons.person,
                size: 40,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(width: 20),
            Text(
              userName,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
