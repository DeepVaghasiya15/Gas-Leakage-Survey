import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var card = Container(
      height: 80,
      child: Card(
        elevation: 4,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: ListTile(
          dense: false,
          // leading: FlutterLogo(),
          title: Text(
            "Pending",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          // subtitle: Text(
          //   "Instructor: Mustafa Tahir",
          //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          // ),
          // trailing: Icon(Icons.arrow_forward_ios),
        ),
      ),
    );

    return Theme(
      data: ThemeData(
        appBarTheme: AppBarTheme(
          foregroundColor: Colors.white, // Text color of AppBar title and leading icon
          iconTheme: IconThemeData(color: Colors.black), // Color of leading icon
        ),
        tabBarTheme: TabBarTheme(
          labelColor: Color(0xFF222831), // Selected tab text color
          unselectedLabelColor: Colors.black.withOpacity(0.5), // Unselected tab text color
          indicator: BoxDecoration(
            // Custom indicator decoration
            border: Border(
              bottom: BorderSide(color: Color(0xFF222831), width: 2.5), // Orange underline for the selected tab
            ),
          ),
        ),
        splashColor: Colors.black, // Splash color when tapping on a tab
        highlightColor: Colors.grey, // Highlight color when tapping on a tab
      ),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "History",
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: Column(
            children: [
              TabBar(tabs: [
                Tab(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.pending_actions_outlined,
                        color: Color(0xFF76ABAE),
                        size: 19,
                      ),
                      Text("Pending")
                    ],
                  ),
                ),
                Tab(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Color(0xFF76ABAE),
                        size: 19,
                      ),
                      Text("Closed")
                    ],
                  ),
                )
              ]),
              Expanded(
                child: TabBarView(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          card,
                          card,
                        ],
                      ),
                    ),
                    // Widget for Our Solution
                    Container(
                      child: Center(
                        child: Text('Closed'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
