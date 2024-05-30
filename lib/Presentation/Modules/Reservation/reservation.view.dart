import 'dart:typed_data';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:online_reservation/Data/Models/department.model.dart';
import 'package:online_reservation/Presentation/Modules/Department/department.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Event/event.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Event/eventList.view.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/message.widget.dart';
import 'package:online_reservation/Utils/utils.dart';
import 'package:online_reservation/config/app.color.dart';
import 'package:provider/provider.dart';

import 'package:online_reservation/Data/Models/event.model.dart';
import 'package:online_reservation/Data/Models/facility.model.dart';
import 'package:online_reservation/Data/Models/equipment.model.dart';
import 'package:online_reservation/Presentation/Modules/Employee/employee.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Authentication/auth.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Facility/facilityList.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Reservation/reservation.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/responsiveLayout.widget.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/customPurpleContainer.widget.dart';

class ReservationScreenArguments {
  final String? slipNo;
  final RequestType? type;

  ReservationScreenArguments({this.slipNo, this.type});
}

class ReservationScreen extends StatefulWidget {
  static const screen_id = "/reservation";
  final ReservationScreenArguments? args;

  const ReservationScreen({super.key, this.args});
  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  late bool enabled;
  late Event event;

  bool stateLoaded = false;
  late String? _statusValue;
  late TextEditingController _requesitionerController;
  late TextEditingController _departmentController;
  late TextEditingController _contactNoController;
  late TextEditingController _eventNameController;
  late TextEditingController _eventDescriptionController;
  late TextEditingController _participantNumberController;
  late TextEditingController _quantityController;
  late TextEditingController _additionalRequirementsController;

  DateTime _selectedStartDate = DateTime.now().add(const Duration(days: 1));
  DateTime _selectedEndDate = DateTime.now().add(const Duration(days: 7)); // Default end time is 1 hour later
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime = TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute);

  Facility? selectedFacility;
  Equipment? selectedEquipment;
  List<EventEquipment> addedEquipments = [];

  Uint8List? _fileBytes;
  String? _fileName;
  String? _filePath;
  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpeg', 'png', 'jpg'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        // You can use fileBytes directly or write it to the web filesystem if needed
        // Example: Upload file bytes to a server or use them locally
        setState(() {
          _fileName = file.name;
          // For demonstration purposes: print file details
          if (kIsWeb) {
            _fileBytes = file.bytes;
            event.fileUpload = _fileBytes;
            print('File Name: $_fileName');
            print('File Bytes: $_fileBytes');
          } else {
            _filePath = file.path;
            event.filePath = _filePath;
            print('File Name: $_fileName');
            print('File Path: $_filePath');
          }
        });
      }
    } catch (e) {
      // Handle any errors here
      print("Error picking file: $e");
    }
  }

  void _pickStartTime() async {
    final TimeOfDay? startTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.inputOnly,
      helpText: "Select Start Time",
      context: context,
      initialTime: _selectedStartTime,
    );
    if (startTime == null) return; // User canceled the picker

    setState(() {
      _selectedStartTime = startTime;
    });
  }

  void _pickEndTime() async {
    final TimeOfDay? endTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.inputOnly,
      helpText: "Select End Time",
      context: context,
      initialTime: _selectedEndTime,
    );
    if (endTime == null) return; // User canceled the picker

    setState(() {
      _selectedEndTime = endTime;
    });
  }

  void _pickStartEndTime() async {
    final TimeOfDay? startTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.inputOnly,
      helpText: "Select Start Time",
      context: context,
      initialTime: _selectedStartTime,
    );
    if (startTime == null) return;

    final TimeOfDay? endTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.inputOnly,
      helpText: "Select End Time",
      context: context,
      initialTime: _selectedEndTime,
    );
    if (endTime == null) return; // User canceled the picker

    setState(() {
      _selectedStartTime = startTime;
      _selectedEndTime = endTime;
    });
  }

  void _pickStartDate() async {
    final DateTime? startDate = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (startDate == null) return; // User canceled the picker

    setState(() {
      _selectedStartDate = startDate;
    });
  }

  void _pickEndDate() async {
    final DateTime? endDate = await showDatePicker(
      // helpText: "Select End Date",

      context: context,
      initialDate: _selectedEndDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2050),
    );
    if (endDate == null) return; // User canceled the picker

    setState(() {
      _selectedEndDate = endDate;
    });
  }

  void _pickStartEndDate() async {
    final initialStartDate = _selectedStartDate;
    if (_selectedStartDate.isBefore(DateTime.now().add(const Duration(days: 1)))) {
      setState(() {
        _selectedStartDate = DateTime.now().add(const Duration(days: 1));
      });
    }
    final DateTime? startEndDate = await showDatePicker(
      // helpText: "Select End Date",

      context: context,
      initialDate: _selectedStartDate,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime(2050),
    );
    if (startEndDate == null) {
      setState(() {
        _selectedStartDate = initialStartDate;
      });
      return; // User canceled the picker
    }

    setState(() {
      _selectedStartDate = startEndDate;
      _selectedEndDate = startEndDate;
    });
  }

  void _showFacilityPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Consumer<FacilityViewModel>(
            builder: (context, viewModel, child) => Wrap(
              children: viewModel.facilities.map((facility) {
                return ListTile(
                  title: Text(facility.name),
                  onTap: () {
                    setState(() {
                      selectedFacility = facility;
                      Navigator.pop(context);
                    });
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _showConfirmationDialog(RequestType type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<EventViewModel>(builder: (context, eventViewModel, child) {
          return AlertDialog(
            title: const Text('Confirm'),
            content: Text(
                'Are you sure you want to ${Utils.formatEnumString(type.toString().split('.').last)} reservation?'),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  var cancel = event.status == 'confirmed' ? true : false;

                  setState(() {
                    event.event_name = _eventNameController.text;
                    event.event_description = _eventDescriptionController.text;
                    event.contact_number = _contactNoController.text;
                    event.additional_needs = _additionalRequirementsController.text;
                    event.reserved_facility = selectedFacility?.id;
                    event.department = Provider.of<EmployeeViewModel>(context, listen: false).profile?.department ?? 1;
                    event.participants_quantity = int.parse(_participantNumberController.text);
                    event.start_time = Utils.combineDateTime(_selectedStartDate, _selectedStartTime);
                    event.end_time = Utils.combineDateTime(_selectedEndDate, _selectedEndTime);
                    event.equipments = addedEquipments;
                    event.status = _statusValue;
                    event.fileUpload = _fileBytes;
                    event.fileName = _fileName;
                  });
                  bool success;

                  switch (type) {
                    case RequestType.Create:
                      // TODO: Handle this case.
                      // success = await eventViewModel.registerEvent(event);
                      await eventViewModel.registerEvent(event);
                      break;
                    case RequestType.Update:
                      // TODO: Handle this case.
                      // success = await eventViewModel.updateEvent(event);
                      await eventViewModel.updateEvent(event);
                      break;
                    case RequestType.Delete:
                      // TODO: Handle this case.
                      if (cancel) {
                        // success = await eventViewModel.cancelEvent(event.slip_number!);
                        await eventViewModel.cancelEvent(event.slip_number!);
                      } else {
                        // success = await eventViewModel.deleteEvent(event.id!);
                        await eventViewModel.deleteEvent(event.id!);
                      }
                      break;
                    case RequestType.Read:
                      // TODO: Handle this case.
                      success = false;
                      break;
                  }
                  if (type == RequestType.Delete) {
                    // Navigator.of(context).pop();
                    Navigator.of(context).popAndPushNamed(EventListScreen.screen_id);
                  } else {
                    Navigator.of(context).pop();
                  }

                  // if (mounted) {
                  //   Navigator.of(context).popAndPushNamed(EventListScreen.screen_id);
                  //   if (success) {
                  //     showDialog(
                  //       context: context,
                  //       builder: (BuildContext context) {
                  //         return AlertDialog(
                  //           title: const Text('Confirmed'),
                  //           content: const Text('Process Success!'),
                  //           actions: <Widget>[
                  //             TextButton(
                  //               onPressed: () {
                  //                 Navigator.of(context).pop(); // Close the dialog
                  //                 // Navigator.of(context).popAndPushNamed(
                  //                 //     EventListScreen.screen_id);
                  //               },
                  //               child: const Text('OK'),
                  //             ),
                  //           ],
                  //         );
                  //       },
                  //     );
                  //   } else {
                  //     Navigator.of(context).pop();
                  //     showDialog(
                  //       context: context,
                  //       builder: (BuildContext context) {
                  //         return AlertDialog(
                  //           title: const Text('Error'),
                  //           content: const Text('Reservation failed'),
                  //           actions: <Widget>[
                  //             TextButton(
                  //               onPressed: () {
                  //                 Navigator.of(context).pop(); // Close the dialog
                  //                 // Navigator.of(context).popAndPushNamed(
                  //                 //     EventListScreen.screen_id);
                  //               },
                  //               child: const Text('OK'),
                  //             ),
                  //           ],
                  //         );
                  //       },
                  //     );
                  //   }
                  // }
                },
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('No'),
              ),
            ],
          );
        });
      },
    );
  }

  bool _isDisabled(String status) {
    if (event.status == 'confirmed' || event.status == 'cancelled' || event.status == 'returned') {
      return status == 'confirmed' || status == 'cancelled' || status == 'returned';
    }
    return false;
  }

  Future<void> initData() async {
    var getEventFuture = widget.args?.slipNo != null
        ? Provider.of<EventViewModel>(context, listen: false).fetchEvent(widget.args!.slipNo!)
        : Future.value(null);
    try {
      Provider.of<EventViewModel>(context, listen: false).resetMessage();
      // Gather all asynchronous operations.
      await Future.wait([
        Provider.of<EquipmentViewModel>(context, listen: false).fetchEquipment(),
        Provider.of<DepartmentViewModel>(context, listen: false).fetchDepartment(),
        Provider.of<FacilityViewModel>(context, listen: false).fetchFacilities(),
        Provider.of<AuthenticationViewModel>(context, listen: false).refreshAccessToken(),
        Provider.of<EmployeeViewModel>(context, listen: false).fetchProfile().then((_) {
          _requesitionerController.text =
              "${Provider.of<EmployeeViewModel>(context, listen: false).profile?.firstName ?? ""} ${Provider.of<EmployeeViewModel>(context, listen: false).profile?.lastName}";
          _departmentController.text =
              Provider.of<EmployeeViewModel>(context, listen: false).profile?.departmentDetails?.name ?? "";
        }),
        Provider.of<EmployeeViewModel>(context, listen: false).fetchEmployees(),
        getEventFuture,
      ]);

      // Use a short delay to simulate a network call (if needed).
      await Future.delayed(const Duration(seconds: 1));

      // Check if the widget is still mounted before calling setState.
      if (mounted) {
        setState(() {
          if (widget.args?.slipNo != null) {
            event = Provider.of<EventViewModel>(context, listen: false).userEvent!;
            _statusValue = event.status;
            _contactNoController.text = event.contact_number!;
            _eventNameController.text = event.event_name!;
            _eventDescriptionController.text = event.event_description!;
            _participantNumberController.text = event.participants_quantity?.toString() ?? "";
            _additionalRequirementsController.text = event.additional_needs ?? "";
            _selectedStartDate = Utils.extractDateOnly(event.start_time);
            _selectedEndDate = Utils.extractDateOnly(event.end_time);
            _selectedStartTime = Utils.extractTimeOnly(event.start_time);
            _selectedEndTime = Utils.extractTimeOnly(event.end_time);
            selectedFacility = Provider.of<FacilityViewModel>(context, listen: false)
                .facilities
                .firstWhereOrNull((facility) => facility.id == event.reserved_facility);
            addedEquipments = event.equipments ?? [];
            _fileName = event.file?.split('/').last;
            _requesitionerController.text =
                '${Provider.of<EmployeeViewModel>(context, listen: false).employees.firstWhere((emp) => emp.id == event.requesitioner).firstName ?? ""} ${Provider.of<EmployeeViewModel>(context, listen: false).employees.firstWhere((emp) => emp.id == event.requesitioner).lastName ?? ""}';
            var requesitionerDept = Provider.of<EmployeeViewModel>(context, listen: false)
                .employees
                .firstWhere((emp) => emp.id == event.requesitioner)
                .department;
            if (event.department == null) {
              _departmentController.text = (Provider.of<DepartmentViewModel>(context, listen: false)
                      .departments
                      .firstWhere((dept) => dept.id == requesitionerDept)
                      .name) ??
                  "";
            } else {
              _departmentController.text = (Provider.of<DepartmentViewModel>(context, listen: false)
                      .departments
                      .firstWhere((dept) => dept.id == event.department)
                      ?.name) ??
                  "";
            }
          } else {
            event = Event(
                event_name: "test",
                start_time: Utils.combineDateTime(_selectedStartDate, _selectedStartTime),
                end_time: Utils.combineDateTime(_selectedEndDate, _selectedEndTime));
            _statusValue = "draft";
          }
          stateLoaded = true;
          enabled = widget.args?.type == RequestType.Read ? false : true;
        });
      }
    } catch (error) {
      // Handle or log errors
      print('Error fetching data: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    event = Event(event_name: "event_name", start_time: _selectedStartDate, end_time: _selectedEndDate);
    _requesitionerController = TextEditingController();
    _departmentController = TextEditingController();
    _contactNoController = TextEditingController();
    _eventNameController = TextEditingController();
    _eventDescriptionController = TextEditingController();
    _participantNumberController = TextEditingController();
    _additionalRequirementsController = TextEditingController();
    _quantityController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
    if(event.file != null) {
      Future.microtask(() async => _fileBytes = await Utils.downloadFile(event.file!));
    }
  }

  @override
  void dispose() {
    // Provider.of<EventViewModel>(context, listen: false).resetMessage();
    _requesitionerController.dispose();
    _departmentController.dispose();
    _contactNoController.dispose();
    _eventNameController.dispose();
    _eventDescriptionController.dispose();
    _participantNumberController.dispose();
    _additionalRequirementsController.dispose();
    _quantityController.dispose();
    // for (var controller in _equipmentControllers) {
    //   controller.dispose();
    // }
    super.dispose();
  }

  Widget body() {
    return Consumer3<EmployeeViewModel, EquipmentViewModel, EventViewModel>(
        builder: (context, employeeViewModel, equipmentViewModel, eventViewModel, child) {
      if (equipmentViewModel.isLoading || employeeViewModel.isLoading || eventViewModel.isLoading || !stateLoaded) {
        return const Center(child: CircularProgressIndicator());
      }
      return Stack(children: [
        SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (eventViewModel.successMessage.isNotEmpty)
                    SuccessMessage(
                      message: eventViewModel.successMessage,
                    ),
                  if (eventViewModel.errorMessage.isNotEmpty)
                    ErrorMessage(
                      message: eventViewModel.errorMessage,
                    ),
                  Text("Requesitioner Details", style: Theme.of(context).textTheme.titleLarge),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          enabled: false,
                          controller: _requesitionerController,
                          decoration: const InputDecoration(
                            labelText: 'Requesitioner',
                            hintText: 'Enter your name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the event name';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 50),
                      Expanded(
                        child: TextFormField(
                          enabled: false,
                          controller: _departmentController,
                          decoration: const InputDecoration(
                            labelText: 'Department',
                            hintText: 'Enter Department',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    enabled: enabled,
                    maxLength: 11,
                    controller: _contactNoController,
                    decoration: const InputDecoration(
                      labelText: 'Contact No.',
                      hintText: '09234567890',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (value.isNotEmpty) {}
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your mobile number';
                      } else if (!RegExp(r'^09\d{9}$').hasMatch(value)) {
                        return 'Please enter a valid 11-digit mobile number starting with 09';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Text("Event Details", style: Theme.of(context).textTheme.titleLarge),
                      ),
                      CustomContainer(
                          child: DropdownButton<String>(
                        value: _statusValue,
                        onChanged: enabled
                            // && event.status != 'confirmed'
                            ? (String? newValue) {
                                setState(() {
                                  _statusValue = newValue;
                                });
                              }
                            : null,
                        items: <String>[
                          'draft',
                          'application',
                          if (widget.args != null)
                            if (event.status == 'cancelled' &&
                                (widget.args?.type == RequestType.Update || widget.args?.type == RequestType.Read))
                              'cancelled',
                          if (event.status == 'returned' &&
                              (widget.args?.type == RequestType.Update || widget.args?.type == RequestType.Read))
                            'returned',
                          if (event.status == 'confirmed' &&
                              (widget.args?.type == RequestType.Update || widget.args?.type == RequestType.Read))
                            'confirmed'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            enabled:!_isDisabled(value),
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                color: Colors.deepPurple[400],
                              ),
                            ),
                          );
                        }).toList(),
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 42,
                        underline: const SizedBox(),
                      )),
                    ],
                  ),
                  TextFormField(
                    enabled: enabled,
                    controller: _eventNameController,
                    decoration: const InputDecoration(
                      labelText: 'Event Name',
                      hintText: 'Enter the name of the event',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the event name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    enabled: enabled,
                    controller: _eventDescriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Event Description',
                      hintText: 'Describe the event',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    enabled: enabled,
                    controller: _participantNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Number of Participants',
                      hintText: 'Enter the number of participants',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (value.isNotEmpty) {}
                    },
                    validator: (value) {
                      if (value == null || (value).isEmpty) {
                        return 'Please enter a description';
                      } else if (0 >= int.parse(value)) {
                        return 'Number must not be equal or less than zero';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),
                  Text("Selected Facility", style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: enabled ? _showFacilityPicker : null,
                    child: Text(
                        selectedFacility == null ? 'Select Facility' : 'Facility: ${selectedFacility?.name ?? ""}'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Layout File (*.PDF, *.JPEG)",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: enabled ? _pickFile : null,
                        child: const Text('Upload File'),
                      ),
                      const SizedBox(width: 20),
                      // _pickedFile == null
                      //     ? const Expanded(child: Text('No file selected.'))
                      //     : Expanded(
                      //         child: Text(
                      //             'File selected: ${_pickedFile!.path.split('/').last}')),
                      const SizedBox(height: 20),
                      // if (_fileBytes != null)
                      //   Image.memory(_fileBytes!, height: 200, errorBuilder: (context, error, stackTrace) => Text("Failed to load image")),
                      if (_fileName != null) Expanded(child: Text('File name: $_fileName')),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text("Date & Time", style: Theme.of(context).textTheme.titleLarge),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          enabled: enabled,
                          title: const Text("Select Date"),
                          subtitle: Text(_selectedStartDate.toLocal().toString().split(' ')[0]),
                          onTap: _pickStartEndDate,
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          enabled: enabled,
                          title: const Text("Select Time Slot"),
                          subtitle: Text("${_selectedStartTime.format(context)} - ${_selectedEndTime.format(context)}"),
                          onTap: _pickStartEndTime,
                        ),
                      ),
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: ListTile(
                  //         enabled: enabled,
                  //         title: const Text("Select Start Time"),
                  //         subtitle: Text(_selectedStartTime.format(context)),
                  //         onTap: _pickStartTime,
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: ListTile(
                  //         enabled: enabled,
                  //         title: const Text("Select End Time"),
                  //         subtitle: Text(_selectedEndTime.format(context)),
                  //         subtitle: Text(_selectedEndTime.format(context)),
                  //         onTap: _pickEndTime,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 20),
                  Text("Materials & Personnel", style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text('Equipment', style: Theme.of(context).textTheme.titleMedium),
                          ),
                          Expanded(
                            child: Container(
                                alignment: Alignment.center,
                                child: Text('Available ', style: Theme.of(context).textTheme.titleMedium)),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text('Amount needed', style: Theme.of(context).textTheme.titleMedium),
                            ),
                          ),
                          const SizedBox(width: 100),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: CustomContainer(
                                child: DropdownButton<Equipment>(
                              isExpanded: true,
                              value: selectedEquipment,
                              onChanged: enabled
                                  ? (Equipment? newValue) {
                                      setState(() {
                                        selectedEquipment = newValue;
                                        _quantityController.clear();
                                      });
                                    }
                                  : null,
                              items:
                                  equipmentViewModel.equipments.map<DropdownMenuItem<Equipment>>((Equipment equipment) {
                                return DropdownMenuItem<Equipment>(
                                  value: equipment,
                                  child: Text(
                                    equipment.equipment_name,
                                    style: TextStyle(
                                      color: Colors.deepPurple[400],
                                    ),
                                  ),
                                );
                              }).toList(),
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 42,
                              underline: const SizedBox(),
                            )),
                          ),
                          Expanded(
                              child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                      selectedEquipment == null ? '0' : '${selectedEquipment!.equipment_quantity}'))),
                          // SizedBox(width: 20),
                          Expanded(
                            child: TextFormField(
                              enabled: enabled,
                              controller: _quantityController,
                              decoration: const InputDecoration(
                                labelText: 'Quantity',
                                hintText: 'Enter quantity',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: ElevatedButton(
                              onPressed: enabled
                                  ? () {
                                      if (selectedEquipment != null && _quantityController.text.isNotEmpty) {
                                        if (int.parse(_quantityController.text) >
                                                selectedEquipment!.equipment_quantity ||
                                            int.parse(_quantityController.text) < 0) {
                                          return;
                                        }
                                        if (!addedEquipments
                                            .any((equipment) => equipment.equipment == (selectedEquipment?.id ?? 0))) {
                                          setState(() {
                                            addedEquipments.add(EventEquipment(
                                                equipment: selectedEquipment!.id,
                                                equipment_name: selectedEquipment!.equipment_name,
                                                quantity: int.parse(_quantityController.text)));
                                          });
                                        }
                                      }
                                    }
                                  : null,
                              child: const Text('Add'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: addedEquipments.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  enabled: enabled,
                                  onTap: () {
                                    // setState(() {
                                    //
                                    // });
                                  },
                                  title: Text(addedEquipments[index].equipment_name),
                                  subtitle: Text('Quantity: ${addedEquipments[index].quantity}'),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: enabled
                                        ? () {
                                            // Action to perform on button press
                                            setState(() {
                                              addedEquipments.removeAt(index);
                                            });
                                          }
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text("Additional Information", style: Theme.of(context).textTheme.titleLarge),
                  // Add more form fields for additional information as needed
                  TextFormField(
                    enabled: enabled,
                    controller: _additionalRequirementsController,
                    decoration: const InputDecoration(
                      labelText: 'Special Requirements',
                      hintText: 'Any special needs or requirements?',
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (enabled)
                    if (widget.args?.slipNo == null)
                      ElevatedButton(
                        onPressed: () {
                          if (selectedFacility == null) {
                            const snackBar = SnackBar(
                              content: Text('Please pick a facility!'),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            return;
                          }
                          if (_formKey.currentState!.validate()) {
                            // Process the reservation
                            print("Processing reservation...");
                            _showConfirmationDialog(RequestType.Create);
                          }
                        },
                        child: const Text('Submit Reservation'),
                      )
                    else
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Process the reservation
                                print("Processing reservation...");
                                _showConfirmationDialog(RequestType.Update);
                              }
                            },
                            child: const Text('Update Reservation'),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          TextButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Process the reservation
                                print("Processing reservation...");
                                _showConfirmationDialog(RequestType.Delete);
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return Colors.red[700]!; // Background color when pressed
                                  }
                                  return Colors.red; // Default background color
                                },
                              ),
                              overlayColor: MaterialStateProperty.all(Colors.red[200]), // Splash color on press
                            ),
                            child: Text(
                              "${event.status == 'confirmed' ? 'Cancel' : 'Delete'} Reservation",
                              style: const TextStyle(color: kBackgroundGrey),
                            ),
                          ),
                        ],
                      ),
                ],
              ),
            ),
          ),
        ),
        if (eventViewModel.isLoading)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: body(),
      desktopBody: body(),
      currentRoute: ReservationScreen.screen_id,
      title: 'Make a Reservation',
    );
  }
}

enum RequestType { Create, Update, Delete, Read }
