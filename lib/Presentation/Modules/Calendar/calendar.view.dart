import 'package:flutter/material.dart';
import 'package:online_reservation/Data/Models/event.model.dart';
import 'package:online_reservation/Presentation/Modules/Event/event.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Facility/facilityList.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/responsiveLayout.widget.dart';
import 'package:online_reservation/Utils/utils.dart';
import 'package:online_reservation/config/app.color.dart';
import 'package:provider/provider.dart';
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
  late List<int> hours;

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

  Future<void> fetchDataFromAPI() async {
    try {
      // Gather all asynchronous operations.
      await Future.wait([
        Provider.of<EventViewModel>(context, listen: false).fetchAllEvents(),
        Provider.of<EventViewModel>(context, listen: false).fetchUserEvents(),
        Provider.of<FacilityViewModel>(context, listen: false)
            .fetchFacilities(),
      ]);

      // Use a short delay to simulate a network call (if needed).
      await Future.delayed(Duration(seconds: 1));

      // Check if the widget is still mounted before calling setState.
      if (mounted) {
        setState(() {
          // var list =
          //     Provider.of<EventViewModel>(context, listen: false).events;
          // for(var i=0;i<list.length;i++){
          //   events.add(list[i]);
          //   events[i].start_time = Utils.combineDateTime(list[i].start_time, Utils.extractTimeOnly(list[i].start_time));
          //   events[i].end_time = Utils.combineDateTime(list[i].start_time, Utils.extractTimeOnly(list[i].end_time));
          //   if(list[i].start_time.day != list[i].end_time.day){
          //     events.add(list[i]);
          //     events[i++].start_time = Utils.combineDateTime(list[i].start_time, Utils.extractTimeOnly(list[i].start_time));
          //     events[i++].end_time = Utils.combineDateTime(list[i].start_time, Utils.extractTimeOnly(list[i].end_time));
          //   }
          // }
        });
      }
    } catch (error) {
      // Handle or log errors
      print('Error fetching data: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    hours = List.generate(24, (index) => index);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchDataFromAPI();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: body(),
      desktopBody: body(),
      currentRoute: CalendarScreen.screen_id,
      title: 'Schedules',
    );
  }

  Widget body() {
    return Consumer2<EventViewModel, FacilityViewModel>(
      builder: (context, eventViewModel, facilityViewModel, child) {
        if (eventViewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
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
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                      24,
                      (index) {
                        List<Widget> hourEvents = eventViewModel.scheduledEvents
                            .where((event) =>
                                event.start_time.day == _focusedDay.day)
                            .where((event) {
                          return roundToNearestQuarter(event.start_time).hour ==
                              index;
                        }).map((event) {
                          double topMargin =
                              (roundToNearestQuarter(event.start_time).minute /
                                  1); // Adjust top margin based on start time
                          double height = _getEventHeight(
                              roundToNearestQuarter(event.start_time),
                              roundToNearestQuarter(event
                                  .end_time)); // Adjust height based on duration
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
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            '${event.event_name ?? ""} - ${event.status?.toUpperCase() ?? "unknown"}'),
                                        Text(
                                            '${facilityViewModel.facilities.firstWhere((facility) => facility.id == event.reserved_facility).name ?? ""} '),
                                      ],
                                    ))),
                          );
                        }).toList();
                        return Stack(clipBehavior: Clip.none, children: [
                          ListTile(
                            title:
                                Text('${index.toString().padLeft(2, '0')}:00'),
                          ),
                          ...hourEvents
                        ]);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class EventListItem extends StatefulWidget {
  final int index;
  final List<Widget> hourEvents;
  const EventListItem(
      {super.key, required this.index, required this.hourEvents});

  @override
  State<EventListItem> createState() => _EventListItemState();
}

class _EventListItemState extends State<EventListItem>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ListTile(
          title: Text('${widget.index.toString().padLeft(2, '0')}:00'),
        ),
        ...widget.hourEvents,
      ],
    );
  }
}
