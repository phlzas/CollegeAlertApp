import 'package:flutter/material.dart';

class AddAlertScreen extends StatefulWidget {
  final Function(String, String, String, DateTime) onAdd;

  const AddAlertScreen({required this.onAdd, super.key});

  @override
  _AddAlertScreenState createState() => _AddAlertScreenState();
}

class _AddAlertScreenState extends State<AddAlertScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  String type = 'Seminar';
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();

  final List<String> types = ['Seminar', 'Exam', 'Fest', 'Notice'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Alert")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Enter Alert Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                  prefixIcon: Icon(Icons.title),
                ),
                onChanged: (val) => title = val,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter a title' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description),
                ),
                onChanged: (val) => description = val,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter a description' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: type,
                items: types
                    .map((t) =>
                        DropdownMenuItem<String>(value: t, child: Text(t)))
                    .toList(),
                onChanged: (val) => setState(() => type = val!),
                decoration: const InputDecoration(
                  labelText: 'Type',
                  prefixIcon: Icon(Icons.category),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text("Date: ${date.toLocal().toString().split(' ')[0]}"),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 30),
                        ),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        setState(() => date = picked);
                      }
                    },
                    child: const Text("Pick Date"),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text("Time: ${time.format(context)}"),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: time,
                      );
                      if (pickedTime != null) {
                        setState(() => time = pickedTime);
                      }
                    },
                    child: const Text("Pick Time"),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.add_alert),
                label: const Text("Add Alert"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final combinedDateTime = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      time.hour,
                      time.minute,
                    );
                    widget.onAdd(title, description, type, combinedDateTime);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ Alert added successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );

                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
