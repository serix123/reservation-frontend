import 'package:flutter/material.dart';

class ReservationScreen extends StatefulWidget {
  static const screen_id ="/reservation";

  const ReservationScreen({super.key});
  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _eventNameController = TextEditingController();
  TextEditingController _eventDescriptionController = TextEditingController();
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now().add(Duration(hours: 1)); // Default end time is 1 hour later
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime = TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Make a Reservation"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Event Details", style: Theme.of(context).textTheme.headline6),
                TextFormField(
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
                const SizedBox(height: 20),
                Text("Date & Time", style: Theme.of(context).textTheme.headline6),
                ListTile(
                  title: const Text("Select Date"),
                  subtitle: Text("${_selectedStartDate.toLocal().toString().split(' ')[0]} - ${_selectedEndDate.toLocal().toString().split(' ')[0]}"),
                  onTap: _pickDateRange,
                ),
                ListTile(
                  title: const Text("Select Time"),
                  subtitle: Text("${_selectedStartTime.format(context)} - ${_selectedEndTime.format(context)}"),
                  onTap: _pickTimeRange,
                ),
                const SizedBox(height: 20),
                Text("Additional Information", style: Theme.of(context).textTheme.headline6),
                // Add more form fields for additional information as needed
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Special Requirements',
                    hintText: 'Any special needs or requirements?',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Process the reservation
                      print("Processing reservation...");
                    }
                  },
                  child: const Text('Submit Reservation'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _pickTimeRange() async {
    final TimeOfDay? startTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.inputOnly,
      helpText: "Select Start Time",
      context: context,
      initialTime: _selectedStartTime,
    );
    if (startTime == null) return;  // User canceled the picker

    final TimeOfDay? endTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.inputOnly,
      helpText: "Select End Time",
      context: context,
      initialTime: _selectedEndTime,
    );
    if (endTime == null) return;  // User canceled the picker

    setState(() {
      _selectedStartTime = startTime;
      _selectedEndTime = endTime;
    });
  }
  void _pickDateRange() async {
    final DateTime? startDate = await showDatePicker(
      context: context,
        initialDate: _selectedStartDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
    );
    if (startDate == null) return;  // User canceled the picker

    final DateTime? endDate = await showDatePicker(
      helpText: "Select End Date",
      context: context,
      initialDate: _selectedEndDate,
      firstDate: _selectedStartDate,
      lastDate: DateTime(2100),

    );
    if (endDate == null) return;  // User canceled the picker

    setState(() {
      _selectedStartDate = startDate;
      _selectedEndDate = endDate;
    });
  }
  DateTime combineDateTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

}
