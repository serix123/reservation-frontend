import 'package:flutter/material.dart';
import 'package:online_reservation/Data/Models/employee.model.dart';
import 'package:online_reservation/Data/Models/facility.model.dart';
import 'package:online_reservation/Presentation/Modules/Authentication/auth.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Department/department.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Employee/employee.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Facility/facilityList.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/message.widget.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/responsiveLayout.widget.dart';
import 'package:online_reservation/Presentation/route/route.generator.dart';
import 'package:provider/provider.dart';

class FacilityScreen extends StatefulWidget {
  static const String screen_id = "/facility";

  const FacilityScreen({super.key});
  @override
  State<FacilityScreen> createState() => _FacilityScreenState();
}

class _FacilityScreenState extends State<FacilityScreen> {

  Future<void> fetchDataFromAPI() async {
    try {
      // Gather all asynchronous operations.
      Provider.of<FacilityViewModel>(context, listen: false).resetMessage();
      await Future.wait([
        Provider.of<DepartmentViewModel>(context, listen: false).fetchDepartment(),
        Provider.of<EmployeeViewModel>(context, listen: false).fetchProfile(),
        Provider.of<EmployeeViewModel>(context, listen: false).fetchEmployees(),
        Provider.of<FacilityViewModel>(context, listen: false).fetchFacilities(),
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

  void _updateFacility(BuildContext context, Facility facility, int index) {
    Navigator.of(context).pushNamed(RouteGenerator.facilityUpdateScreen, arguments: facility).then((_) {
      setState(() {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          fetchDataFromAPI();
        });
      });
    });
  }

  void _deleteFacility(Facility facility) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this facility?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async{
                await Provider.of<FacilityViewModel>(context, listen: false).deleteFacility(facility);
                setState(() {});
                await Provider.of<FacilityViewModel>(context, listen: false).fetchFacilities();
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _addFacility() {
    Navigator.of(context).pushNamed(RouteGenerator.facilityUpdateScreen).then((_) {
      setState(() {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          fetchDataFromAPI();
        });
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: body(context),
      desktopBody: body(context),
      currentRoute: FacilityScreen.screen_id,
      title: 'Facility Details',
    );
  }

  Widget body(BuildContext context) {
    return Consumer2<FacilityViewModel, EmployeeViewModel>(
      builder: (context, facilityViewModel, employeeViewModel, child) {
        if (facilityViewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (facilityViewModel.errorMessage.isNotEmpty) {
          return Center(child: Text(facilityViewModel.errorMessage));
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (facilityViewModel.successMessage.isNotEmpty)
                  SuccessMessage(
                    message: facilityViewModel.successMessage,
                  ),
                if (facilityViewModel.errorMessage.isNotEmpty)
                  ErrorMessage(
                    message: facilityViewModel.errorMessage,
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: _addFacility,
                          child: const Text('Add Facilities'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // ElevatedButton(
                      //   onPressed: () {},
                      //   child: const Text('Add from CSV'),
                      // ),
                      // Add other buttons if needed
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 20.0,
                    horizontalMargin: 10.0,
                    columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Department')),
                      DataColumn(label: Text('Person-in-Charge')),
                      DataColumn(label: Text('Description')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: List.generate(facilityViewModel.facilities.length, (index) {
                      final facility = facilityViewModel.facilities[index];
                      Employee? employee;
                      if (facility.person_in_charge != null) {
                        employee = employeeViewModel.employees.firstWhere(
                            (element) =>
                                facility.person_in_charge == null ? false : element.id == facility.person_in_charge,
                            orElse: () => Employee(id: 999, firstName: "", lastName: ""));
                      } else {
                        employee = null;
                      }
                      return DataRow(cells: [
                        DataCell(Text(facility.id?.toString() ?? '-')),
                        DataCell(Text(facility.name ?? '-')),
                        DataCell(Text(facility.department?.toString() ?? '-')),
                        DataCell(Text(
                            "${facility.person_in_charge != null ? (employee?.firstName ?? "") : ""} ${facility.person_in_charge != null ? (employee?.lastName ?? "") : ""} (${facility.person_in_charge?.toString() ?? '-'})")),
                        DataCell(Text(facility.facility_description ?? '-')),
                        DataCell(
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () => _updateFacility(context, facility, index),
                                child: const Text('Update'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () => _deleteFacility(facility),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text('Delete'),
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
          ),
        );
      },
    );
  }
}
