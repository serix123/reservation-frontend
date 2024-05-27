import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';

class EmployeeCSVImportScreen extends StatefulWidget {
  static const String screen_id = "/employeeRegisterCSV";
  const EmployeeCSVImportScreen({super.key});

  @override
  _EmployeeCSVImportScreenState createState() => _EmployeeCSVImportScreenState();
}

class _EmployeeCSVImportScreenState extends State<EmployeeCSVImportScreen> {
  List<List<dynamic>> _csvData = [];

  Future<void> _importCSV() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        String csvString = await file.readAsString();
        List<List<dynamic>> csvTable = const CsvToListConverter().convert(csvString);
        setState(() {
          _csvData = csvTable;
        });
      }
    } catch (e) {
      print('Error importing CSV: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CSV Import'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Upload your CSV file:',
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _importCSV,
                child: Text('Choose File'),
              ),
              SizedBox(height: 20.0),
              Expanded(
                child: ListView.builder(
                  itemCount: _csvData.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('${_csvData[index][1]} ${_csvData[index][2]}'), // Assuming the first two columns are first name and last name
                      subtitle: Text('Email: ${_csvData[index][0]}'), // Email column
                      trailing: Text('Department ID: ${_csvData[index][4]}'), // Department ID column
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}