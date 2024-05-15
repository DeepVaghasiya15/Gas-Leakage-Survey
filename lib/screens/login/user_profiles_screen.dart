import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

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
        padding: const EdgeInsets.only(top: 10.0,bottom: 10),
        child: ListView.builder(
          itemCount: 10, // Assuming you have 10 users
          itemBuilder: (context, index) {
            // Generate a unique key for each UserCard
            Key userCardKey = UniqueKey();
            return UserCard(
              userName: "User ${index + 1}",
              key: userCardKey,
              // You can pass the user profile picture here
              // userProfileImage: userProfileImages[index],
            );
          },
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final String userName;
  // Add more properties here like userProfileImage if needed

  const UserCard({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle user selection here
      },
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
              // User profile picture can be displayed here
              // backgroundImage: NetworkImage(userProfileImage),
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
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
          ],
        ),
      ),
    );
  }
}
