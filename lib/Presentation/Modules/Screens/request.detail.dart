import 'package:flutter/material.dart';

class RequestDetailScreen extends StatelessWidget {
  static const String screen_id = "/details";
  final String request;

  const RequestDetailScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Request Details"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Card(
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  request,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Logic for rejection can be added here
                  },
                  child: Text('Reject'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Red color for the reject button
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Logic for approval can be added here
                  },
                  child: Text('Approve'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Green color for the approve button
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
