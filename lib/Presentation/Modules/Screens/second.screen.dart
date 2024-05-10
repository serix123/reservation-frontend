import 'package:flutter/material.dart';
import 'package:online_reservation/config/app.color.dart';
import 'package:online_reservation/config/dimensions.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});
  static const String screen_id = "/second";

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  late List<DateTime> days;

  int getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  List<DateTime> getDaysOfMonth({int? year, int? month}) {
    // Set default values to current year and month if not provided
    final int currentYear = year ?? DateTime.now().year;
    final int currentMonth = month ?? DateTime.now().month;
    final int daysCount = getDaysInMonth(currentYear, currentMonth);

    List<DateTime> days = List.generate(daysCount, (index) {
      return DateTime(currentYear, currentMonth, index + 1);
    });
    return days;
  }

  final List<String> daysOfWeek = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun"
  ];
  final List<String> hoursOfDay =
      List.generate(24, (index) => "${index + 1}:00"); // Hours from 1 to 24
  final List<String> employees = ["Alice", "Bob", "Charlie", "David"];
  bool selectEmployee = true; // Toggle between showing week or hours

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    days = getDaysOfMonth();
  }

  @override
  Widget build(BuildContext context) {
    List<String> displayColumns = hoursOfDay;
    double screenWidth = MediaQuery.of(context).size.width;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Weekly Schedule"),
            actions: [
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () {
                  setState(() {
                    selectEmployee = !selectEmployee;
                  });
                },
              ),
            ],
          ),
          body: Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey,
            child: Expanded(
              child: SingleChildScrollView(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: kPurpleDark),
                          ),
                          width: 120,
                          height: 32,
                          alignment: Alignment.center,
                          child: const Text('Employee'),
                        ),
                        if (selectEmployee)
                          ...employees.map(
                            (employee) => Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: kPurpleDark),
                              ),
                              width: 120,
                              height: 32,
                              alignment: Alignment.center,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: kPurpleDark,
                                  padding: EdgeInsets.zero, // Removes padding
                                  tapTargetSize: MaterialTapTargetSize
                                      .shrinkWrap, // Minimizes the tap area
                                  textStyle: const TextStyle(
                                      decoration: TextDecoration
                                          .underline), // Underline text
                                ),
                                onPressed: () {
                                  setState(() {
                                    selectEmployee = !selectEmployee;
                                  });
                                },
                                child: Text(employee),
                              ),
                            ),
                          )
                        else
                          ...days.map(
                            (day) => Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: kPurpleDark),
                              ),
                              width: 120,
                              height: 32,
                              alignment: Alignment.center,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: kPurpleDark,
                                  padding: EdgeInsets.zero, // Removes padding
                                  tapTargetSize: MaterialTapTargetSize
                                      .shrinkWrap, // Minimizes the tap area
                                  textStyle: TextStyle(
                                      decoration: TextDecoration
                                          .underline), // Underline text
                                ),
                                onPressed: () {
                                  setState(() {
                                    selectEmployee = !selectEmployee;
                                  });
                                },
                                child: Text('${day.toString()}'),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: constraints.maxWidth > mobileWidth
                            ? SizedBox(
                                width: constraints.maxWidth * .90,
                                child: Table(
                                  columnWidths: <int, TableColumnWidth>{
                                    for (int i = 0;
                                        i <= displayColumns.length;
                                        i++)
                                      i: constraints.maxWidth > mobileWidth
                                          ? const FlexColumnWidth(1)
                                          // FixedColumnWidth((constraints.maxWidth / 28))
                                          : const FixedColumnWidth(
                                              75), // Fixed width for all other columns
                                  },
                                  defaultColumnWidth:
                                      constraints.maxWidth > mobileWidth
                                          ? const FlexColumnWidth(1)
                                          : const FixedColumnWidth(75),
                                  border: TableBorder.all(color: Colors.black),
                                  children: [
                                    TableRow(
                                      // Header row
                                      children: [
                                        for (var col in displayColumns)
                                          Container(
                                              height: 32,
                                              alignment: Alignment.center,
                                              child: Text(col))
                                      ],
                                    ),
                                    if (selectEmployee)
                                      ...employees.map(
                                        (employee) {
                                          return TableRow(
                                            // Rows for each employee
                                            children: [
                                              ...displayColumns.map(
                                                (_) => Container(
                                                  height: 32,
                                                  alignment: Alignment.center,
                                                  child: const Text(''),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      )
                                    else
                                      ...days.map(
                                        (day) {
                                          return TableRow(
                                            // Rows for each employee
                                            children: [
                                              ...displayColumns.map(
                                                (_) => Container(
                                                  height: 32,
                                                  alignment: Alignment.center,
                                                  child: const Text(''),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                  ],
                                ),
                              )
                            : Table(
                                columnWidths: <int, TableColumnWidth>{
                                  for (int i = 0;
                                      i <= displayColumns.length;
                                      i++)
                                    i: const FixedColumnWidth(
                                        75), // Fixed width for all other columns
                                },
                                defaultColumnWidth: const FixedColumnWidth(75),
                                border: TableBorder.all(color: Colors.black),
                                children: [
                                  TableRow(
                                    // Header row
                                    children: [
                                      for (var col in displayColumns)
                                        Container(
                                            height: 32,
                                            alignment: Alignment.center,
                                            child: Text(col))
                                    ],
                                  ),
                                  if (selectEmployee)
                                    ...employees.map(
                                      (employee) {
                                        return TableRow(
                                          // Rows for each employee
                                          children: [
                                            ...displayColumns.map(
                                              (_) => Container(
                                                height: 32,
                                                alignment: Alignment.center,
                                                child: const Text(''),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    )
                                  else
                                    ...days.map(
                                      (day) {
                                        return TableRow(
                                          // Rows for each employee
                                          children: [
                                            ...displayColumns.map(
                                              (_) => Container(
                                                height: 32,
                                                alignment: Alignment.center,
                                                child: const Text(''),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
