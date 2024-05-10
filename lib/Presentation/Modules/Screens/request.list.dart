import 'package:flutter/material.dart';
import 'package:online_reservation/Presentation/Modules/Screens/request.detail.dart';

class RequestListScreen extends StatefulWidget {
  const RequestListScreen({super.key});
  static const String screen_id = "/request";

  @override
  _RequestListScreenState createState() => _RequestListScreenState();
}

class _RequestListScreenState extends State<RequestListScreen> {
  List<String> requests = [
    "Request 1: Follow-up on the report",
    "Request 2: Update software",
    "Request 3: Schedule meeting",
    "Request 4: Review new application",
    "Request 5: Check email settings",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Requests'),
      ),
      body: ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(requests[index]),
              subtitle: Text("Tap for more details"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RequestDetailScreen(request: requests[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}