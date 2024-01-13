import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project2/course_screen.dart';
import 'package:project2/model/user.dart';
import 'dart:convert';
import 'package:project2/util.dart';

class RegisterCourseScreen extends StatefulWidget {
  final User user;

  const RegisterCourseScreen({super.key, required this.user});

  @override
  _RegisterCourseScreenState createState() => _RegisterCourseScreenState();
}

class _RegisterCourseScreenState extends State<RegisterCourseScreen> {
  TextEditingController _courseNameController = TextEditingController();
  TextEditingController _dueDateController = TextEditingController();
  TimeOfDay? _selectedTime;
  TextEditingController _courseDescriptionController = TextEditingController();
  String _selectedCategory = 'Cooking';

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void registerCourse() async {
    final url = Uri.https(firebaseUrl, 'courses.json');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'Course Name': _courseNameController.text,
            'Date': _dueDateController.text,
            'Time': _selectedTime != null ? _selectedTime!.format(context) : '',
            'Categories': _selectedCategory,
            'Description': _courseDescriptionController.text,
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Course registered successfully!');
      } else {
        print('Failed to register course. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error registering course: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Course'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _courseNameController,
              decoration: InputDecoration(labelText: 'Course Name'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _dueDateController,
              decoration: InputDecoration(labelText: 'Date'),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2021),
                  lastDate: DateTime(2028),
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                      ),
                      child: child!,
                    );
                  },
                );

                if (pickedDate != null) {
                  _dueDateController.text = pickedDate.toString().split(' ')[0];
                }
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: TextEditingController(
                  text: _selectedTime != null ? _selectedTime!.format(context) : ''),
              decoration: InputDecoration(labelText: 'Time'),
              readOnly: true,
              onTap: _selectTime,
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Categories'),
              value: _selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
              items: <String>['Cooking', 'Mathematics', 'Coding']
                  .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _courseDescriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                registerCourse();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CourseScreen(user: widget.user)),
                );
              },
              child: Text('Register Course'),
            ),
          ],
        ),
      ),
    );
  }
}