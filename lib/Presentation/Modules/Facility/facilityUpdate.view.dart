import 'package:flutter/material.dart';
import 'package:online_reservation/Data/Models/department.model.dart';
import 'package:online_reservation/Data/Models/facility.model.dart';
import 'package:online_reservation/Presentation/Modules/Department/department.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Facility/facilityList.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/message.widget.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/responsiveLayout.widget.dart';
import 'package:provider/provider.dart';

import '../Employee/employee.viewmodel.dart';

class FacilityEditScreen extends StatefulWidget {
  static const String screen_id = "/facilityUpdate";
  final Facility? facility;

  const FacilityEditScreen({super.key, this.facility});

  @override
  _FacilityEditScreenState createState() => _FacilityEditScreenState();
}

class _FacilityEditScreenState extends State<FacilityEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late int? _id;
  late String? _name;
  late String? _description;
  late int? _head;
  late int? _departmentId;
  String? _departmentName = '';
  String _searchText = '';
  String _headSearchText = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FacilityViewModel>(context, listen: false).resetMessage();
    });
    if (widget.facility != null) {
      _id = widget.facility?.id;
      _name = widget.facility?.name;
      _head = widget.facility?.person_in_charge;
      _departmentId = widget.facility?.department;
      _description = widget.facility?.facility_description;
    } else {
      _id = null;
      _name = null;
      _head = null;
      _departmentId = null;
      _description = null;
    }
  }

  void _saveFacility()async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Implement your save logic here
      print('Saved facility: $_id, $_name, $_head, $_departmentId, $_departmentName');
    }
    final facility = Facility(
      id: _id ?? 0,
      name: _name ?? "",
      facility_description:_description,
      person_in_charge: _head,
      department:_departmentId ,
    );
    if (widget.facility != null) {
      await Provider.of<FacilityViewModel>(context, listen: false).updateFacility(facility);
    }else{
      await Provider.of<FacilityViewModel>(context, listen: false).createFacility(facility);
    }
    Facility? response = Provider.of<FacilityViewModel>(context, listen: false).facility;
    setState(() {
      _id = response?.id;
      _name = response?.name;
      _description =response?.facility_description;
      _head =response?.person_in_charge;
      _departmentId =response?.department;
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
      mobileBody: body(context),
      desktopBody: body(context),
      currentRoute: FacilityEditScreen.screen_id,
      title: widget.facility != null ? 'Edit Facility' : 'Add Facility',
    );
  }

  Widget body(BuildContext context) {
    return Consumer<FacilityViewModel>(
      builder: (context, facilityViewModel, child) {
        if (facilityViewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                if (facilityViewModel.successMessage.isNotEmpty)
                  SuccessMessage(
                    message: facilityViewModel.successMessage,
                  ),
                if (facilityViewModel.errorMessage.isNotEmpty)
                  ErrorMessage(
                    message: facilityViewModel.errorMessage,
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
                TextFormField(
                  initialValue: _description,
                  decoration: const InputDecoration(labelText: 'Description'),
                  onSaved: (value) => _description = value,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Person-in-Charge: ${_head ?? '-'}'),
                    TextButton(
                      onPressed: () => _selectHead(context),
                      child: const Text('Select Person-in-Charge'),
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
                  onPressed: _saveFacility,
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
