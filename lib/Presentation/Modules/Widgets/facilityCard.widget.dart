import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:online_reservation/Data/Models/department.model.dart';
import 'package:online_reservation/Data/Models/employee.model.dart';
import 'package:online_reservation/Data/Models/facility.model.dart';
import 'package:online_reservation/Presentation/Modules/Department/department.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Employee/employee.viewmodel.dart';
import 'package:provider/provider.dart';

class FacilityCard extends StatelessWidget {
  final Facility facility;

  const FacilityCard({super.key, required this.facility});

  @override
  Widget build(BuildContext context) {
    Department? dept;
    if (facility.department != null) {
      dept = Provider.of<DepartmentViewModel>(context, listen: false).departments.firstWhere(
          (department) => facility.department != null ? department.id == facility.department : false,
          orElse: () => Department(id: 999, name: "Private Department"));
    } else {
      dept = null;
    }
    // Department? dept = Provider.of<DepartmentViewModel>(context, listen: false)
    //     .departments
    //     .firstWhere((department) => department.id == facility.department);
    Employee? emp;
    if (facility.person_in_charge != null) {
      emp = Provider.of<EmployeeViewModel>(context, listen: false).employees.firstWhere(
            (employee) => facility.person_in_charge != null ? employee.id == facility.person_in_charge : false,
            orElse: () => Employee(id: 999, firstName: "Hidden", lastName: "Person"),
          );
    }else {
      emp = null;
    }
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("About Facility"),
                content: Text(facility.facility_description ?? "-"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        },
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: facility.image == null
                      ? Image.asset('assets/images/SISC_BANNER.png')
                      : Image.network(
                          facility.image!,
                          // width: imageWidth,
                          // height: 150,
                        ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ListTile(
                        //   leading: SizedBox(
                        //     height: 150,
                        //     child: Image.network(facility.image!,
                        //       // width: imageWidth,
                        //       // height: 150,
                        //     ),
                        //   ),
                        //   title: Text(facility.name),
                        //   subtitle: Text("Department: ${dept.name}"),
                        // ),
                        Text(
                          facility.name.toUpperCase(),
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        Text("Department: ${dept?.name ?? "TBA"}"),
                        Text(
                          "Person in Charge: ${emp?.firstName ?? "TBA"} ${emp?.lastName ?? ""}",
                          style: TextStyle(color: Colors.black.withOpacity(0.6)),
                        ),
                        // ButtonBar(
                        //   alignment: MainAxisAlignment.start,
                        //   children: [
                        //     TextButton(
                        //       onPressed: () {
                        //         // Implement navigation or other interaction
                        //         print("Navigating to details for ${facility.name}");
                        //       },
                        //       child: Text('DETAILS'),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFacilityDialog() {}
}
