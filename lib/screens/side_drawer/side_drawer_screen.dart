import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SideDrawer extends StatefulWidget {
  const SideDrawer({super.key});

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 288,
        height: double.infinity,
        color: Color(0xFF222831),
        child: SafeArea(
          child: Column(
            children: [
              InfoTile(name: 'Deep Vaghasiya',profession: "Flutter Developer",),
              Divider(color: Colors.white24,),
              DrawerItems(iconData: CupertinoIcons.home, text: "Home"),
              Divider(color: Colors.white10,),
              DrawerItems(iconData: CupertinoIcons.clock, text: "History"),
              Divider(color: Colors.white10,),
              DrawerItems(iconData: CupertinoIcons.hourglass, text: "Pending Route"),
              Divider(color: Colors.white10,),
              DrawerItems(iconData: CupertinoIcons.lock, text: "Change Password"),
              Divider(color: Colors.white10,),
              DrawerItems(iconData: CupertinoIcons.power, text: "Log Out"),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerItems extends StatelessWidget {
  final IconData iconData;
  final String text;

  const DrawerItems({
    super.key,
    required this.iconData,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        iconData, // Default icon is set to Icons.home
        color: Colors.white,
      ),
      title: Text(
        text, // Default text is set to "Home"
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  const InfoTile({
    super.key,
    required this.name,
    required this.profession,
  });

  final String name,profession;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white30,
        child: Icon(CupertinoIcons.person,
        color: Colors.white,),
      ),
      title: Text(
        name,
        style: TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        profession,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
