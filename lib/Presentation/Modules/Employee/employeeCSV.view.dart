import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:online_reservation/Data/Models/auth.model.dart';
import 'package:online_reservation/Data/Models/employee.model.dart';
import 'package:online_reservation/Presentation/Modules/Authentication/auth.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Employee/employee.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/message.widget.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/responsiveLayout.widget.dart';
import 'package:provider/provider.dart';

class EmployeeCSVImportScreen extends StatefulWidget {
  static const String screen_id = "/employeeRegisterCSV";
  const EmployeeCSVImportScreen({super.key});

  @override
  _EmployeeCSVImportScreenState createState() => _EmployeeCSVImportScreenState();
}

class _EmployeeCSVImportScreenState extends State<EmployeeCSVImportScreen> {
  List<List<dynamic>> data = [];
  List<RegistrationCredentials> list = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthenticationViewModel>(context, listen: false).resetMessage();
    });
  }

  Future<void> _uploadCSV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      Uint8List? fileBytes = result.files.single.bytes;

      if (fileBytes != null) {
        String csvData = String.fromCharCodes(fileBytes);
        List<List<dynamic>> csvTable = CsvToListConverter().convert(csvData);

        // Handling null values and parsing specific columns to int
        for (int i = 0; i < csvTable.length; i++) {
          if (i == 0) continue;
          for (int j = 0; j < csvTable[i].length; j++) {
            if (csvTable[i][j] == null) {
              csvTable[i][j] = '';
            } else if (j == 2 || j == 3) {
              csvTable[i][j] = int.tryParse(csvTable[i][j].toString()) ?? 0;
            }
          }
        }

        setState(() {
          data = csvTable;
          for (var item in data) {
            final credentials = RegistrationCredentials(
              first_name: item[0].toString() ?? "",
              last_name: item[1].toString() ?? "",
              email: "${item[0].toString()}_${item[1].toString() ?? ""}@southville.edu.ph",
              employee: Employee(
                  id: 1,
                  firstName: item[0].toString() ?? "",
                  lastName: item[1].toString() ?? "",
                  immediateHead: item[2],
                  department: item[3]),
            );
            list.add(credentials);
          }
        });
      }
    }
  }

  void _saveEmployee() async {
    await Provider.of<AuthenticationViewModel>(context, listen: false).registerByCSV(list);
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: body(),
      desktopBody: body(),
      currentRoute: EmployeeCSVImportScreen.screen_id,
      title: 'Register Employee',
    );
  }

  Widget body() {
    return Consumer2<AuthenticationViewModel, EmployeeViewModel>(
      builder: (context, authenticationViewModel, employeeViewModel, child) {
        if (authenticationViewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _uploadCSV,
                      child: Text('Upload CSV'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: data.isNotEmpty ? _saveEmployee : null,
                      child: Text('Register'),
                    ),
                  ],
                ),
                if (data.isNotEmpty)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('First Name')),
                        DataColumn(label: Text('Last Name')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Head ID')),
                        DataColumn(label: Text('Department ID')),
                      ],
                      rows: data.map((row) {
                        return DataRow(
                          cells: [
                            DataCell(Text(row[0].toString())),
                            DataCell(Text(row[1].toString())),
                            DataCell(Text("${row[0].toString()}_${row[1].toString() ?? ""}@southville.edu.ph")),
                            DataCell(Text(row[2].toString())),
                            DataCell(Text(row[3].toString())),
                          ],
                        );
                      }).toList(),
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
