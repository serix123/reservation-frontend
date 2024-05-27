import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_reservation/Data/Models/employee.model.dart';
import 'package:online_reservation/Presentation/Modules/Authentication/auth.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Department/department.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Employee/employee.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/deleteButton.widget.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/message.widget.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/responsiveLayout.widget.dart';
import 'package:online_reservation/Presentation/route/route.generator.dart';
import 'package:provider/provider.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});
  static const String screen_id = "/employee";

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  Future<void> fetchDataFromAPI() async {
    try {
      // Gather all asynchronous operations.
      await Future.wait([
        Provider.of<DepartmentViewModel>(context, listen: false).fetchDepartment(),
        Provider.of<EmployeeViewModel>(context, listen: false).fetchProfile(),
        Provider.of<EmployeeViewModel>(context, listen: false).fetchEmployees(),
        Provider.of<AuthenticationViewModel>(context, listen: false).refreshAccessToken()
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

  void _updateEmployee(BuildContext context, Employee employee) {
    Navigator.of(context).pushNamed(RouteGenerator.employeeUpdateScreen, arguments: employee).then((_) {
      // Handle any updates or state changes after returning from the edit screen
      setState(() {});
    });
  }

  void _deleteEmployee(Employee employee) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this employee?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await Provider.of<EmployeeViewModel>(context, listen: false).deleteEmployee(employee);
                setState(() {
                });
                await Provider.of<EmployeeViewModel>(context, listen: false).fetchEmployees();
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: body(),
      desktopBody: body(),
      currentRoute: EmployeesScreen.screen_id,
      title: 'Employees',
    );
  }

  Widget body() {
    return Consumer<EmployeeViewModel>(
      builder: (context, employeeViewModel, child) {
        if (employeeViewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (employeeViewModel.successMessage.isNotEmpty)
                  SuccessMessage(
                    message: employeeViewModel.successMessage,
                  ),
                if (employeeViewModel.errorMessage.isNotEmpty)
                  ErrorMessage(
                    message: employeeViewModel.errorMessage,
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pushNamed(RouteGenerator.employeeRegisterScreen),
                      child: const Text('Add Employee'),
                    ),
                    const SizedBox(width: 8),
                    // ElevatedButton(
                    //   onPressed: () => Navigator.of(context).pushNamed(RouteGenerator.employeeRegisterCSVScreen),
                    //   child: const Text('Add from CSV'),
                    // ),
                    // Add other buttons if needed
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Immediate Head')),
                      DataColumn(label: Text('Department Name')),
                      DataColumn(label: Text('Department ID')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: employeeViewModel.employees.map((employee) {
                      return DataRow(cells: [
                        DataCell(Text(employee.id.toString() ?? '-')),
                        DataCell(Text('${employee.firstName} ${employee.lastName}')),
                        DataCell(Text(employee.immediateHead?.toString() ?? '-')),
                        DataCell(Text(employee.departmentDetails?.name ?? '-')),
                        DataCell(Text(employee.department?.toString() ?? '-')),
                        DataCell(
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () => _updateEmployee(context, employee),
                                child: Text('Update'),
                              ),
                              SizedBox(width: 8),
                              DeleteButton(
                                text: "Delete",
                                onPressed: () => _deleteEmployee(employee),
                              ),
                            ],
                          ),
                        ),
                        // DataCell(
                        //   ElevatedButton(
                        //     onPressed: () {
                        //       Navigator.of(context).pushNamed(RouteGenerator.employeeUpdateScreen,arguments: employee);
                        //     },
                        //     child: Text('Update'),
                        //   ),
                        // ),
                      ]);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
        // return ListView.builder(
        //   itemCount: employeeViewModel.employees.length,
        //   itemBuilder: (context, index) {
        //     var employee = employeeViewModel.employees[index];
        //     return ListTile(
        //       title: Text('${employee.firstName} ${employee.lastName}'),
        //       subtitle: Text(
        //           'Head: ${employee.immediateHeadDetails?.firstName} ${employee.immediateHeadDetails?.lastName} - Dept: ${employee.department}'),
        //     );
        //   },
        // );
      },
    );
  }
}
