import 'package:flutter/material.dart';
import 'package:online_reservation/Data/Models/department.model.dart';
import 'package:online_reservation/Data/Models/employee.model.dart';
import 'package:online_reservation/Presentation/Modules/Department/department.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Employee/employee.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/deleteButton.widget.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/message.widget.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/responsiveLayout.widget.dart';
import 'package:online_reservation/Presentation/route/route.generator.dart';
import 'package:provider/provider.dart';

class DepartmentScreen extends StatefulWidget {
  static const String screen_id = "/department";

  const DepartmentScreen({super.key});
  @override
  State<DepartmentScreen> createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
  void _updateDepartment(BuildContext context, Department department) {
    Navigator.of(context).pushNamed(RouteGenerator.departmentUpdateScreen, arguments: department).then((_) {
      // Handle any updates or state changes after returning from the edit screen
      setState(() {});
    });
  }

  void _deleteDepartment(Department department) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this department?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await Provider.of<DepartmentViewModel>(context, listen: false).deleteDepartment(department);
                setState(() {});
                await Provider.of<DepartmentViewModel>(context, listen: false).fetchDepartment();
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchDataFromAPI() async {
    try {
      // Gather all asynchronous operations.
      await Future.wait([
        Provider.of<DepartmentViewModel>(context, listen: false).fetchDepartment(),
        Provider.of<EmployeeViewModel>(context, listen: false).fetchProfile(),
        Provider.of<EmployeeViewModel>(context, listen: false).fetchEmployees(),
      ]);

      // Use a short delay to simulate a network call (if needed).
      await Future.delayed(const Duration(seconds: 1));

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
    return ResponsiveLayout(
      mobileBody: body(context),
      desktopBody: body(context),
      currentRoute: DepartmentScreen.screen_id,
      title: 'Department Details',
    );
  }

  Widget body(BuildContext context) {
    return Consumer2<DepartmentViewModel, EmployeeViewModel>(
      builder: (context, departmentViewModel, employeeViewModel, child) {
        if (departmentViewModel.isLoading || employeeViewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (departmentViewModel.errorMessage.isNotEmpty) {
          return Center(child: Text(departmentViewModel.errorMessage));
        }
        if (employeeViewModel.errorMessage.isNotEmpty) {
          return Center(child: Text(employeeViewModel.errorMessage));
        }
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (departmentViewModel.successMessage.isNotEmpty)
                SuccessMessage(
                  message: departmentViewModel.successMessage,
                ),
              if (departmentViewModel.errorMessage.isNotEmpty)
                ErrorMessage(
                  message: departmentViewModel.errorMessage,
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pushNamed(RouteGenerator.departmentUpdateScreen),
                      child: const Text('Add Department'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Add from CSV'),
                    ),
                    // Add other buttons if needed
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Immediate Head')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: List.generate(departmentViewModel.departments.length, (index) {
                    final department = departmentViewModel.departments[index];
                    Employee? employee;
                    if (department.immediate_head != null) {
                      employee = employeeViewModel.employees.firstWhere(
                          (element) =>
                              department.immediate_head == null ? false : element.id == department.immediate_head,
                          orElse: () => Employee(id: 999, firstName: "", lastName: ""));
                    } else {
                      employee = null;
                    }
                    return DataRow(cells: [
                      DataCell(Text(department.id.toString() ?? '-')),
                      DataCell(Text(department.name ?? '-')),
                      DataCell(
                        Text(
                            "${department.immediate_head != null ? (employee?.firstName ?? "") : ""} ${department.immediate_head != null ? (employee?.lastName ?? "") : ""} (${department.immediate_head?.toString() ?? '-'})"),
                      ),
                      DataCell(
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () => _updateDepartment(context, department),
                              child: const Text('Update'),
                            ),
                            const SizedBox(width: 8),
                            DeleteButton(
                              text: "Delete",
                              onPressed: () => _deleteDepartment(department),
                            ),
                          ],
                        ),
                      ),
                    ]);
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
