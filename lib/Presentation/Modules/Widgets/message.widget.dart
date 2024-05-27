import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  final String message;

  const Message({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.yellow[100],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.green[700]!),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green[700]),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: TextStyle(color: Colors.green[700]))),
        ],
      ),
    );
  }
}

class SuccessMessage extends StatelessWidget {
  final String message;

  const SuccessMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.green[700]!),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green[700]),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: TextStyle(color: Colors.green[700]))),
        ],
      ),
    );
  }
}

class ErrorMessage extends StatelessWidget {
  final String message;

  const ErrorMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.red[100],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.red[700]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error, color: Colors.red[700]),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: TextStyle(color: Colors.red[700]))),
        ],
      ),
    );
  }
}