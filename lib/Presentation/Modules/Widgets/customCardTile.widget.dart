import 'package:flutter/material.dart';

class CustomCardTile extends StatelessWidget {
  final String? title;  // Now nullable
  final IconData? icon;  // Now nullable
  final VoidCallback onTap;

  const CustomCardTile({
    Key? key,
    this.title,  // Nullable
    this.icon,  // Nullable
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: icon != null ? Icon(icon, color: Theme.of(context).primaryColor) : null,
        title: title != null ? Text(title!) : null,
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }
}
