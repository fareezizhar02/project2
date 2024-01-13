import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:project2/model/user.dart';
import 'package:project2/util.dart';

class MyCourseScreen extends StatefulWidget {
  final User user;

  const MyCourseScreen({Key? key, required this.user}) : super(key: key);

  @override
  _MyCourseScreenState createState() => _MyCourseScreenState();
}

class _MyCourseScreenState extends State<MyCourseScreen> {
  List<String> _courses = [];

  Future<void> fetchCourses() async {
    final response = await http.get(
        Uri.https(firebaseUrl, 'users/${widget.user.userId}/registeredCourses.json'));

    if (response.statusCode == 200) {
      final Map<String, dynamic>? data = json.decode(response.body);

      if (data != null) {
        List<String> courses = [];

        data.forEach((key, value) {
          if (value != null) {
            courses.add(value['courseName'] ?? '');
            courses.add(value['date'] ?? '');
            courses.add(value['time'] ?? '');
          }
        });

        // Convert the list of courses into a flat list (concatenating course data)
        List<String> flattenedCourses = [];
        for (int i = 0; i < courses.length; i += 3) {
          flattenedCourses.add('${courses[i]} - ${courses[i + 1]} - ${courses[i + 2]}');
        }

        setState(() {
          _courses = flattenedCourses;
        });
      } else {
        print('Data is null');
      }
    } else {
      print('Failed to load courses');
    }
  }

  Future<void> deleteCourse(String course) async {
    // Update the local state
    setState(() {
      _courses.remove(course);
    });

    // Get the key of the course in the database
    final response = await http.get(
        Uri.https(firebaseUrl, 'users/${widget.user.userId}/registeredCourses.json'));

    if (response.statusCode == 200) {
      final Map<String, dynamic>? data = json.decode(response.body);

      String? courseKey;
      data?.forEach((key, value) {
        if (value != null && value['courseName'] == course) {
          courseKey = key;
        }
      });

      if (courseKey != null) {
        // Update the database using the correct key
        final url = Uri.https(firebaseUrl,
            'users/${widget.user.userId}/registeredCourses/$courseKey.json');

        final deleteResponse = await http.delete(url);

        if (deleteResponse.statusCode != 200) {
          print('Failed to delete course. Status code: ${deleteResponse.statusCode}');
          // If the deletion failed, add the course back to the local state
          setState(() {
            _courses.add(course);
          });
        }
      }
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
      title: Text('My Courses'),
    ),
    body: ListView.builder(
      itemCount: _courses.length,
      itemBuilder: (context, index) {
        List<String> courseDetails = _courses[index].split(' - ');

        return Card(
          child: ListTile(
            title: Text(courseDetails[0]), // Course name as title
            subtitle: Text('${courseDetails[1]}, ${courseDetails[2]}'), // Date and Time as subtitle
            trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => deleteCourse(_courses[index]),
            ),
          ),
        );
      },
    ),
  );
}
}
