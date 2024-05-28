import 'package:flutter/material.dart';
import 'package:online_reservation/Data/Models/auth.model.dart';
import 'package:online_reservation/Data/Models/employee.model.dart';
import 'package:online_reservation/Presentation/Modules/Authentication/auth.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Department/department.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Employee/employee.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/message.widget.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/responsiveLayout.widget.dart';
import 'package:provider/provider.dart';

class EmployeeEditScreen extends StatefulWidget {
  static const String screen_id = "/employeeUpdate";
  final Employee employee;

  const EmployeeEditScreen({super.key, required this.employee});

  @override
  State<EmployeeEditScreen> createState() => _EmployeeEditScreenState();
}

class _EmployeeEditScreenState extends State<EmployeeEditScreen> {
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
    _id = widget.employee.id;
    _firstName = widget.employee.firstName;
    _lastName = widget.employee.lastName;
    _email = widget.employee.email;
    _head = widget.employee.immediateHead;
    _departmentId = widget.employee.department;
  }

  void _saveEmployee() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Implement your save logic here
      // For now, we'll just print the updated employee details
      print('Saved employee: $_id, $_firstName,$_lastName, $_head, $_departmentId, $_departmentName');
    }
    final employee = Employee(
      id: _id!,
      firstName: _firstName ?? "",
      lastName: _lastName ?? "",
      email: _email,
      department: _departmentId,
      immediateHead: _head,
    );
    final updateDetails = UserUpdateDetails(id:widget.employee.user!, email: _email,first_name: _firstName,last_name: _lastName);
    await Provider.of<EmployeeViewModel>(context, listen: false).updateEmployee(employee);
    await Provider.of<AuthenticationViewModel>(context, listen: false).updateByAdmin(updateDetails);
    Employee? response = Provider.of<EmployeeViewModel>(context, listen: false).updatedEmployee;
    setState(() {
      _id = response?.id;
      _firstName = response?.firstName;
      _lastName =response?.lastName;
      _head = response?.immediateHead;
      _departmentId = response?.department;
    });



      // Navigator.pop(context);
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
      currentRoute: EmployeeEditScreen.screen_id,
      title: 'Edit Employee',
    );
  }

  Widget body() {
    return Consumer<EmployeeViewModel>(
      builder: (context, employeeViewModel, child) {
        if (employeeViewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                if (employeeViewModel.successMessage.isNotEmpty)
                  SuccessMessage(message: employeeViewModel.successMessage,),
                if (employeeViewModel.errorMessage.isNotEmpty)
                  ErrorMessage(message: employeeViewModel.errorMessage,),
                TextFormField(
                  enabled: false,
                  initialValue: _id?.toString(),
                  decoration: const InputDecoration(labelText: 'ID'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _id = int.tryParse(value ?? ''),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: _firstName,
                        decoration: const InputDecoration(labelText: 'First Name'),
                        onSaved: (value) => _firstName = value,
                        onChanged: (value) {
                          setState(() {
                            _firstName = value;
                            _email = "${value}_${_lastName ?? ""}@southville.edu.ph";
                          });
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
                        onSaved: (value) => _lastName = value,
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
        ) ;
      },
    );
  }
}
