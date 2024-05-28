import 'package:flutter/material.dart';
import 'package:online_reservation/Data/Models/department.model.dart';
import 'package:online_reservation/Presentation/Modules/Department/department.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Employee/employee.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/message.widget.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/responsiveLayout.widget.dart';
import 'package:provider/provider.dart';

class DepartmentEditScreen extends StatefulWidget {
  static const String screen_id = "/departmentUpdate";
  final Department? department;

  const DepartmentEditScreen({super.key, this.department});

  @override
  State<DepartmentEditScreen> createState() => _DepartmentEditScreenState();
}

class _DepartmentEditScreenState extends State<DepartmentEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late int? _id;
  late String? _name;
  late int? _head;
  String _headSearchText = '';

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

  void _saveDepartment() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Implement your save logic here
      print('Saved department: $_id, $_name, $_head');
    }
    final department = Department(
      id: _id ?? 0,
      name: _name,
      immediate_head: _head,
    );
    if (widget.department != null) {
      await Provider.of<DepartmentViewModel>(context, listen: false).updateDepartment(department);
    }else{
      await Provider.of<DepartmentViewModel>(context, listen: false).createDepartment(department);
    }
    Department? response = Provider.of<DepartmentViewModel>(context, listen: false).department;
    setState(() {
      _id = response?.id;
      _name = response?.name;
      _head =response?.immediate_head;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DepartmentViewModel>(context, listen: false).resetMessage();
    });
    if (widget.department != null) {
      _id = widget.department?.id;
      _name = widget.department?.name;
      _head = widget.department?.immediate_head;
    } else {
      _id = null;
      _name = '';
      _head = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: body(),
      desktopBody: body(),
      currentRoute: DepartmentEditScreen.screen_id,
      title: widget.department != null ? 'Edit Department' : 'Add Department',
    );
  }

  Widget body() {
    return Consumer<DepartmentViewModel>(builder: (context, departmentViewModel, child) {
      if (departmentViewModel.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              if (departmentViewModel.successMessage.isNotEmpty)
                SuccessMessage(
                  message: departmentViewModel.successMessage,
                ),
              if (departmentViewModel.errorMessage.isNotEmpty)
                ErrorMessage(
                  message: departmentViewModel.errorMessage,
                ),
              TextFormField(
                enabled: false,
                initialValue: _id?.toString(),
                decoration: const InputDecoration(labelText: 'ID'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _id = int.tryParse(value ?? ''),
              ),
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                onSaved: (value) => _name = value,
              ),
              const SizedBox(
                height: 20,
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveDepartment,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      );
    });
  }
}
