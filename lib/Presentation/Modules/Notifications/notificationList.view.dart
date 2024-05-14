import 'package:flutter/material.dart';
import 'package:online_reservation/Data/Models/notification.model.dart';
import 'package:online_reservation/Presentation/Modules/Event/event.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/customPurpleContainer.widget.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/statefulWrapper.widget.dart';
import 'package:provider/provider.dart';

import 'notification.viewmodel.dart';

class NotificationScreen extends StatelessWidget {
  static const String screen_id = "/notifications";

  const NotificationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Demo'),
        actions: [
          const NotificationPopupMenu(), // Add the notification bell icon button
        ],
      ),
      body: const Center(
        child: Text('Notification Screen'),
      ),
    );
  }
}

class NotificationPopupMenu extends StatefulWidget {
  const NotificationPopupMenu({super.key});

  @override
  State<NotificationPopupMenu> createState() => _NotificationPopupMenuState();
}

class _NotificationPopupMenuState extends State<NotificationPopupMenu> {
  Future<void> fetchDataFromAPI() async {
    try {
      // Gather all asynchronous operations.
      await Future.wait([
        Provider.of<NotificationViewModel>(context, listen: false)
            .fetchNotifications(),
      ]);

      // Use a short delay to simulate a network call (if needed).
      await Future.delayed(Duration(seconds: 1));

      // Check if the widget is still mounted before calling setState.
      if (mounted) {
        setState(() {});
      }
    } catch (error) {
      // Handle or log errors
      print('Error fetching data: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchDataFromAPI();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationViewModel>(
      builder: (context, notificationViewModel, child) => PopupMenuButton(
        icon: const Icon(Icons.notifications),
        itemBuilder: (BuildContext context) => [
          for (var notification in notificationViewModel.notifications.reversed)
            PopupMenuItem(
              child: CustomContainer(
                child: Column(
                  children: [
                    ListTile(
                      title: Text('${notification.message}'),
                      onTap: null,

                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
