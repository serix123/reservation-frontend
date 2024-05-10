import 'package:flutter/material.dart';
import 'package:online_reservation/Presentation/Modules/Approval/approvalList.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Employee/employee.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Event/event.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/customPurpleContainer.widget.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/responsiveLayout.widget.dart';
import 'package:provider/provider.dart';

class EventListScreen extends StatefulWidget {
  static const String screen_id = '/eventList';
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {

  Future<void> fetchDataFromAPI() async {
    try {
      // Gather all asynchronous operations.
      await Future.wait([
        Provider.of<EventViewModel>(context, listen: false).fetchUserEvents()
      ]);

      // Use a short delay to simulate a network call (if needed).
      await Future.delayed(Duration(seconds: 1));

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

  Widget body() {
    return Consumer<EventViewModel>(
      builder: (BuildContext context, eventViewModel, Widget? child) {
        if (eventViewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: eventViewModel.events.length,
                itemBuilder: (context, index) {
                  final event = eventViewModel.userEvents[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 12),
                    child: CustomContainer(
                      child: ListTile(
                        title: Text(
                          event.event_name ?? "",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.deepPurple[400]),
                        ),
                        subtitle: Text(event.event_description ?? ""),
                        trailing: Text(event.status ?? ""),
                        onTap: () {
                          // Handle the tap event if necessary
                          print('Tapped on ${event.event_name}');
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileBody: body(),
        desktopBody: body(),
        currentRoute: EventListScreen.screen_id,
        title: "Event List");
  }
}
