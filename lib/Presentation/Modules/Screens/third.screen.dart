import 'package:flutter/material.dart';

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({super.key});
  static const String screen_id = "/third";

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  List<String> employees = [
    "Alice",
    "Bob",
    "Charlie",
    "David",
    "Eve",
    "Eve",
    "Eve",
    "Eve",
    "Eve",
    "Eve",
    "Eve",
    "Eve",
    "Eve",
    "Eve",
    "Eve",
    "Eve",
    "Eve",
    "Eve",
    "Eve",
    "Eve",
    "Eve",
    "Eve"
  ];
  final ScrollController _scrollController = ScrollController();

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Timetable'),
        actions: [
          IconButton(
            icon: Icon(Icons.timer),
            onPressed: () => _pickTimeRange(context),
          ),
          IconButton(
            icon: Icon(Icons.arrow_left),
            onPressed: () => _scrollToLeft(),
          ),
          IconButton(
            icon: Icon(Icons.arrow_right),
            onPressed: () => _scrollToRight(),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Expanded(
            child: SingleChildScrollView(
              child: Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  child: SizedBox(
                    width: constraints.maxWidth - 32,
                    child: buildTimePickerTable(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTimePickerTable() {
    return Table(
      border: TableBorder.all(color: Colors.black),
      columnWidths: {0: FixedColumnWidth(100)},
      children: [
        TableRow(
          children: [
            TableCell(child: Container()),
            ...List.generate(24, (index) => TableCell(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                color: Colors.grey[300],
                child: Text('${index}:00', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ))
          ],
        ),
        ...employees.map((name) => TableRow(
          children: [
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.fill,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                color: Colors.blue[100],
                child: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            ...List.generate(24, (index) => TableCell(
              child: Container(
                alignment: Alignment.center,
                height: 40,
                color: isWithinSelectedTimeRange(index) ? Colors.green : Colors.white,
                child: Text(""),
              ),
            ))
          ],
        )),
      ],
    );
  }

  Widget buildTable() {
    return Table(
      border: TableBorder.all(color: Colors.black),
      columnWidths: const {
        0: FixedColumnWidth(100) // Assuming the first column for names
      },
      children: [
        TableRow(
          children: [
            TableCell(child: Container()),
            ...List.generate(
              24,
              (index) => TableCell(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  color: Colors.grey[300],
                  child: Text('${index}:00',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            )
          ],
        ),
        ...employees.map((name) => TableRow(
              children: [
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.fill,
                  child: Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.symmetric(vertical: 5),
                    color: Colors.blue[100],
                    child: Text(name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                ...List.generate(
                    24,
                    (index) => TableCell(
                          child: GestureDetector(
                            onTap: () {
                              print("Tapped $name at ${index}:00");
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              color: index % 2 == 0
                                  ? Colors.white
                                  : Colors.blue[50],
                              child: Text(""),
                            ),
                          ),
                        ))
              ],
            )),
      ],
    );
  }

  void _scrollToLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 100, // Change the value to match your need
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void _scrollToRight() {
    _scrollController.animateTo(
      _scrollController.offset + 100, // Change the value to match your need
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _pickTimeRange(BuildContext context) async {
    final TimeOfDay? startTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.inputOnly,
      helpText: "Select Start Time",
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (startTime == null) return;  // User canceled the picker

    final TimeOfDay? endTime = await showTimePicker(
      helpText: "Select End Time",
      context: context,
      initialTime: startTime,
    );
    if (endTime == null) return;  // User canceled the picker

    setState(() {
      _startTime = startTime;
      _endTime = endTime;
    });
  }

  bool isWithinSelectedTimeRange(int hour) {
    if (_startTime == null || _endTime == null) return false;

    final startHour = _startTime!.hour;
    final endHour = _endTime!.hour;

    return hour >= startHour && hour <= endHour;
  }
}
