import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_reservation/Data/Models/event.model.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/customCard.widget.dart';
import 'package:online_reservation/config/app.color.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  static const String screen_id = "/calendar";

  const CalendarScreen({super.key});
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  late List<Event> events;

  DateTime roundToNearestQuarter(DateTime dateTime) {
    int minutes = dateTime.minute;
    int roundedMinutes;

    if (minutes < 8) {
      roundedMinutes = 0; // Round down to 00
    } else if (minutes < 23) {
      roundedMinutes = 15; // Round to 15
    } else if (minutes < 38) {
      roundedMinutes = 30; // Round to 30
    } else if (minutes < 53) {
      roundedMinutes = 45; // Round to 45
    } else {
      // Round up to the next hour
      return DateTime(
          dateTime.year, dateTime.month, dateTime.day, dateTime.hour + 1);
    }

    return DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour,
        roundedMinutes);
  }

  double _getEventHeight(DateTime start, DateTime end) {
    int totalMinutes = end.difference(start).inMinutes;
    // Assuming each hour slot has a fixed height, say 60 pixels
    // And since there are 4 quarters in an hour, each quarter represents 15 minutes
    // Hence each minute can be represented by 60 / 60 = 1 pixel
    print('${totalMinutes * 1.0}');
    return totalMinutes *
        1.0; // Adjust this scaling factor based on your actual slot height
  }

  @override
  void initState() {
    super.initState();
    events = [
      Event(
        event_name: "Team Standup",
        start_time: DateTime.now().add(Duration(hours: 0)), // 9:00
        end_time: DateTime.now().add(Duration(hours: 0, minutes: 30)), // 9:30
      ),
      Event(
        event_name: "Client Call",
        start_time: DateTime.now().add(Duration(hours: 0, minutes: 30)), // 9:30
        end_time: DateTime.now().add(Duration(hours: 3)), // 10:00
      ),
    ];
    events.forEach((element) {
      print(
          '${(element.event_name)}: ${roundToNearestQuarter(element.start_time)} - ${roundToNearestQuarter(element.end_time)}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule Calendar"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: TableCalendar(
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 24,
                // separatorBuilder: (context, index) => const Divider(height: 1),
                // 24 hour slots
                itemBuilder: (context, index) {
                  // Collect events for this hour
                  List<Widget> hourEvents = events
                      .where((event) => event.start_time.day == _focusedDay.day)
                      .where((event) {
                    return roundToNearestQuarter(event.start_time).hour == index;
                  }).map((event) {
                    double topMargin =
                        (roundToNearestQuarter(event.start_time).minute /
                            1); // Adjust top margin based on start time
                    double height = _getEventHeight(
                        roundToNearestQuarter(event.start_time),
                        roundToNearestQuarter(
                            event.end_time)); // Adjust height based on duration
                    return Positioned(

                      top: topMargin,
                      left: 100,
                      right: 0,
                      child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: kBackgroundGrey,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                              padding: EdgeInsets.all(5),
                              height: height - 2,
                              child: Text(event.event_name))),
                      // child: Container(
                      //   height: height,
                      //   padding: EdgeInsets.zero,
                      //   color: Colors.blue[300],
                      //   child: Text(event.name),
                      // ),
                    );
                  }).toList();

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ListTile(
                        title: Text('${index.toString().padLeft(2, '0')}:00'),
                      ),
                      ...hourEvents,
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
