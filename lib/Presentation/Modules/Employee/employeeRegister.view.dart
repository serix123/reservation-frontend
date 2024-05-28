import 'package:flutter/material.dart';
import 'package:online_reservation/Data/Models/auth.model.dart';
import 'package:online_reservation/Data/Models/employee.model.dart';
import 'package:online_reservation/Presentation/Modules/Authentication/auth.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Department/department.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Employee/employee.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/message.widget.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/responsiveLayout.widget.dart';
import 'package:provider/provider.dart';

class EmployeeRegisterScreen extends StatefulWidget {
  static const String screen_id = "/employeeRegister";

  const EmployeeRegisterScreen({super.key});

  @override
  State<EmployeeRegisterScreen> createState() => _EmployeeRegisterScreenState();
}

class _EmployeeRegisterScreenState extends State<EmployeeRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late int? _id;
  late String? _firstName;
  late String? _lastName;
  late String? _email;
  late int? _head;
  late int? _departmentId;
  String? _departmentName = '';
  String _searchText = '';
  String _headSearchText = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthenticationViewModel>(context, listen: false).resetMessage();
      Provider.of<EmployeeViewModel>(context, listen: false).resetMessage();
    });
    _id = null;
    _firstName = null;
    _lastName = null;
    _email = null;
    _head = null;
    _departmentId = null;
  }

  void _saveEmployee() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Implement your save logic here
      // For now, we'll just print the updated employee details
      print('Saved employee: $_id, $_firstName,$_lastName,$_email, $_head, $_departmentId, $_departmentName');
    }
    final credentials = RegistrationCredentials(
      email: _email!,
      first_name: _firstName ?? "",
      last_name: _lastName ?? "",
      employee: Employee(
          id: 1,
          firstName: _firstName ?? "",
          lastName: _lastName ?? "",
          immediateHead: _head,
          department: _departmentId),
    );
    await Provider.of<AuthenticationViewModel>(context, listen: false).registerByAdmin(credentials).then((_) async {
      // return await Future.wait([
      //   Provider.of<DepartmentViewModel>(context, listen: false).fetchDepartment(),
      //   Provider.of<EmployeeViewModel>(context, listen: false).fetchProfile(),
      //   Provider.of<EmployeeViewModel>(context, listen: false).fetchEmployees(),
      //   Provider.of<AuthenticationViewModel>(context, listen: false).refreshAccessToken()
      // ]);
    });
  }

  void _selectDepartment(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Consumer<DepartmentViewModel>(
            builder: (context, departmentViewModel, child) {
              if (departmentViewModel.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setModalState) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'Search',
                              prefixIcon: Icon(Icons.search),
                            ),
                            onChanged: (value) {
                              setModalState(() {
                                _searchText = value;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            children: departmentViewModel.departments
                                .where((department) =>
                                    department.name!.toLowerCase().contains(_searchText.toLowerCase()) ||
                                    department.id.toString().contains(_searchText))
                                .map((department) {
                              return ListTile(
                                title: Text(department.name ?? ""),
                                subtitle: Text("ID: ${department.id.toString()}"),
                                onTap: () {
                                  setState(() {
                                    _departmentId = department.id;
                                    _departmentName = department.name;
                                    _head = department.immediate_head;
                                  });
                                  Navigator.pop(context);
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          );
        });
  }

  void _selectHead(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Consumer<EmployeeViewModel>(
          builder: (context, employeeViewModel, child) {
            if (employeeViewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Search Head',
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          setModalState(() {
                            _headSearchText = value;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: employeeViewModel.employees
                            .where((employee) =>
                                employee.firstName.toLowerCase().contains(_headSearchText.toLowerCase()) ||
                                employee.lastName.toLowerCase().contains(_headSearchText.toLowerCase()) ||
                                employee.id.toString().contains(_headSearchText.toLowerCase()))
                            .map((employee) {
                          return ListTile(
                            title: Text('${employee.firstName} ${employee.lastName}'),
                            subtitle: Text('ID: ${employee.id.toString()}'),
                            onTap: () {
                              setState(() {
                                _head = employee.id;
                              });
                              Navigator.pop(context);
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: body(),
      desktopBody: body(),
      currentRoute: EmployeeRegisterScreen.screen_id,
      title: 'Edit Employee',
    );
  }

  Widget body() {
    return Consumer2<AuthenticationViewModel, EmployeeViewModel>(
      builder: (context, authenticationViewModel, employeeViewModel, child) {
        if (authenticationViewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                if (authenticationViewModel.successMessage.isNotEmpty)
                  SuccessMessage(
                    message: authenticationViewModel.successMessage,
                  ),
                if (authenticationViewModel.errorMessage.isNotEmpty)
                  ErrorMessage(
                    message: authenticationViewModel.errorMessage,
                  ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: _firstName,
                        decoration: const InputDecoration(labelText: 'First Name'),
                        onChanged: (value) {
                          setState(() {
                            _firstName = value;
                            _email = "${value}_${_lastName ?? ""}@southville.edu.ph";
                          });
                        },
                        onSaved: (value) {
                          _firstName = value;
                          // _email = "${value}_${_lastName ?? ""}@southville.edu.ph";
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: _lastName,
                        decoration: const InputDecoration(labelText: 'Last Name'),
                        onSaved: (value) {
                          _lastName = value;
                          // _email = "${_firstName}_${value ?? ""}@southville.edu.ph";
                        },
                        onChanged: (value) {
                          setState(() {
                            _lastName = value;
                            _email = "${_firstName}_${value ?? ""}@southville.edu.ph";
                            print(_email);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text('Email: ${_email ?? '-'}'),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Head: ${_head ?? '-'}'),
                    TextButton(
                      onPressed: () => _selectHead(context),
                      child: const Text('Select Head'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Department ID: ${_departmentId ?? '-'}'),
                    TextButton(
                      onPressed: () => _selectDepartment(context),
                      child: const Text('Select Department'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveEmployee,
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
