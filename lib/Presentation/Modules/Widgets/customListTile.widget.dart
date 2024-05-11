

import 'package:flutter/material.dart';

class CustomNavigationListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String routeName;

  CustomNavigationListTile({super.key, required this.title, required this.icon, required this.routeName});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 2, // Adjust shadow elevation
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title),
        onTap: () => Navigator.of(context).pushNamed(routeName),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }
}
