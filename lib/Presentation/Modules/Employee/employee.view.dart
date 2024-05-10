import 'package:flutter/material.dart';
import 'package:online_reservation/Presentation/Modules/Authentication/auth.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Employee/employee.viewmodel.dart';
import 'package:provider/provider.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});
  static const String screen_id = "/employee";

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {

  @override
  void initState() {
    super.initState();
    // Initialize the ViewModel and fetch employees
    // _viewModel = Provider.of<EmployeeViewModel>(context, listen: false);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (_viewModel.employees.isEmpty) {
    //     _viewModel.fetchEmployees();
    //   }
    // });
    // _viewModel.fetchEmployees();
    Future.microtask(() =>
        Provider.of<EmployeeViewModel>(context, listen: false).fetchEmployees()
    );
    Future.microtask(() =>
        Provider.of<AuthenticationViewModel>(context, listen: false).refreshAccessToken()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employees"),
      ),
      body: Consumer<EmployeeViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if(viewModel.errorMessage.isNotEmpty){
            return Center(child: Text(viewModel.errorMessage));
          }
          return ListView.builder(
            itemCount: viewModel.employees.length,
            itemBuilder: (context, index) {
              var employee = viewModel.employees[index];
              return ListTile(
                title: Text('${employee.firstName} ${employee.lastName}'),
                subtitle: Text(
                    'Head: ${employee.immediateHeadDetails?.firstName} ${employee.immediateHeadDetails?.lastName} - Dept: ${employee.department}'),
              );
            },
          );

        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          // viewModel.fetchEmployees();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
