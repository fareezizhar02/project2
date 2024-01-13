import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project2/model/user.dart';
import 'dart:convert';

import 'package:project2/util.dart';

class ScheduleScreen extends StatefulWidget {
  final User user;

  const ScheduleScreen({super.key, required this.user});
  
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  List<Map<String, dynamic>> _courses = [];

  Future<void> fetchCourses() async {
    try {
      final response = await http.get(
        Uri.https(firebaseUrl, 'users/${widget.user.userId}/registeredCourses.json'));


      if (response.statusCode == 200) {
        final Map<String, dynamic>? data = json.decode(response.body);

        if (data != null) {
          List<Map<String, dynamic>> courses = [];

          data.forEach((key, value) {
            if (value != null) {
              courses.add({
                'day': value['day'],
                'date': value['date'],
                'time': value['time'],
                'courseName': value['courseName'],
              });
            }
          });

          setState(() {
            _courses = courses;
          });
        } else {
          print('Data is null');
        }
      } else {
        print('Failed to load courses. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching courses: $error');
    }
  }

  @override
  void initState() {
    fetchCourses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Screen'),
      ),
      body: ListView.builder(
        itemCount: _courses.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text('${_courses[index]['date']}'),
              subtitle: Text('${_courses[index]['time']}'),
              trailing: Text('${_courses[index]['courseName']}'),
            ),
          );
        },
      ),
    );
  }
}
