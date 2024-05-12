import 'package:flutter/material.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});
  static const String screen_id = "/timetable";

  @override
  _TimetableScreenState createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  List<String> employees = ["Alice", "Bob", "Charlie", "David", "Eve"];
  final ScrollController _scrollController = ScrollController();

  Map<String, TimeRange> selectedTimes = {}; // Stores time range for each employee
  String? _selectedEmployee; // Track the selected employee

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Timetable'),
        actions: [
          if (_selectedEmployee != null)
            IconButton(
              icon: Icon(Icons.timer),
              onPressed: () => _pickTimeRange(context),
            ),
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _selectedEmployee = null;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        // scrollDirection: Axis.horizontal,
        controller: _scrollController,
        child: LayoutBuilder(
            builder: (context, constraints) =>
                SizedBox(width: constraints.maxWidth, child: buildTable())),
      ),
    );
  }

  Widget buildTable() {
    return Table(
      border: TableBorder.all(color: Colors.black),
      columnWidths: {0: FixedColumnWidth(100)},
      children: [
        TableRow(
          children: [
            TableCell(child: Container()),
            ...List.generate(
                24,
                (index) => TableCell(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                        color: Colors.grey[300],
                        child: Text('${index}:00',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ))
          ],
        ),
        ...employees.map((name) => TableRow(
              children: [
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.fill,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedEmployee = name;
                      });
                    },
                    child: Container(
                      alignment: Alignment.topCenter,
                      // padding: EdgeInsets.symmetric(vertical: 20),
                      color: _selectedEmployee == name
                          ? Colors.amber
                          : Colors.blue[100],
                      child: Text(name,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                ...List.generate(
                    24,
                    (index) => TableCell(
                          child: Container(
                            alignment: Alignment.center,
                            height: 40,
                            color: _selectedEmployee == name &&
                                isWithinSelectedTimeRange(name, index)
                                ? Colors.green
                                : Colors.white,
                            child: Text(""),
                          ),
                        ))
              ],
            )),
      ],
    );
  }

  void _pickTimeRange(BuildContext context) async {
    final TimeOfDay? startTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (startTime == null) return;  // User canceled the picker

    final TimeOfDay? endTime = await showTimePicker(
      context: context,
      initialTime: startTime,
    );
    if (endTime == null) return;  // User canceled the picker

    setState(() {
      selectedTimes[_selectedEmployee!] = TimeRange(startTime, endTime);
    });
  }

  bool isWithinSelectedTimeRange(String name, int hour) {
    if (!selectedTimes.containsKey(name)) return false;

    final range = selectedTimes[name]!;
    final startHour = range.start.hour;
    final endHour = range.end.hour;

    return hour >= startHour && hour <= endHour;
  }
}

class TimeRange {
  final TimeOfDay start;
  final TimeOfDay end;

  TimeRange(this.start, this.end);
}

