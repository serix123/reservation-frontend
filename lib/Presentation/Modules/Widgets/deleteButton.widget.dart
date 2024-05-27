import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  const DeleteButton({
    super.key,
    this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
      ),
      child: Text(text, style: TextStyle(color: Colors.white)),
    );
  }
}