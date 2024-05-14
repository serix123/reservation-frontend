import 'package:flutter/material.dart';
import 'package:online_reservation/Presentation/Modules/Department/department.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Employee/employee.viewmodel.dart';
import 'package:provider/provider.dart';

import 'package:online_reservation/Presentation/Modules/Facility/facilityList.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/responsiveLayout.widget.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/facilityCard.widget.dart';

class FacilitiesScreen extends StatefulWidget {
  static const screen_id = "/facility";

  const FacilitiesScreen({super.key});

  @override
  State<FacilitiesScreen> createState() => _FacilitiesScreenState();
}

class _FacilitiesScreenState extends State<FacilitiesScreen> {
  late FacilityViewModel viewmodel;

  Future<void> initData() async {
    try {
      // Gather all asynchronous operations.
      await Future.wait([
        Provider.of<EmployeeViewModel>(context, listen: false).fetchEmployees(),
        Provider.of<FacilityViewModel>(context, listen: false)
            .fetchFacilities(),
        Provider.of<DepartmentViewModel>(context, listen: false)
            .fetchDepartment(),
      ]);

      // Use a short delay to simulate a network call (if needed).
      await Future.delayed(const Duration(seconds: 1));

      // Check if the widget is still mounted before calling setState.
      if (mounted) {}
    } catch (error) {
      // Handle or log errors
      print('Error fetching data: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: body(),
      desktopBody: body(),
      currentRoute: FacilitiesScreen.screen_id,
      title: 'Facilities',
    );
  }

  Widget body() {
    return Consumer3<EmployeeViewModel, FacilityViewModel, DepartmentViewModel>(
      builder: (context, employeeViewModel, facilityViewModel,
          departmentViewModel, child) {
        if (facilityViewModel.isLoading ||
            employeeViewModel.isLoading ||
            departmentViewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (facilityViewModel.errorMessage.isNotEmpty) {
          return Center(child: Text(facilityViewModel.errorMessage));
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: facilityViewModel.facilities.length,
                  itemBuilder: (context, index) {
                    return FacilityCard(
                        facility: facilityViewModel.facilities[index]);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
