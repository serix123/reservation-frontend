import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:online_reservation/config/app.color.dart';
import 'package:online_reservation/config/dimensions.dart';

class FirstScreen extends StatefulWidget {
  static const String screen_id = "/first";
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
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
  bool showWeek = true; // Toggle between showing week or hours

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> displayColumns = showWeek ? daysOfWeek : hoursOfDay;
    double screenWidth = MediaQuery.of(context).size.width;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Weekly Schedule"),
            actions: [
              IconButton(
                icon: Icon(showWeek ? Icons.watch_later : Icons.calendar_today),
                onPressed: () {
                  setState(() {
                    showWeek = !showWeek;
                  });
                },
              ),
            ],
          ),
          body: Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
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
                      ...employees.map(
                        (employee) => Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: kPurpleDark),
                          ),
                          width: 120,
                          height: 32,
                          alignment: Alignment.center,
                          child: Text(employee),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 12,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: constraints.maxWidth > mobileWidth
                        ? SizedBox(
                            width: constraints.maxWidth * .85,
                            child: Table(
                              columnWidths: <int, TableColumnWidth>{
                                for (int i = 0; i <= displayColumns.length; i++)
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
                                ...employees.map(
                                  (employee) => TableRow(
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
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Table(
                            columnWidths: <int, TableColumnWidth>{
                              for (int i = 0; i <= displayColumns.length; i++)
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
                              ...employees.map(
                                (employee) => TableRow(
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
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
