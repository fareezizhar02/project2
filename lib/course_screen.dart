import 'package:flutter/material.dart';
import 'package:project2/model/course.dart';
import 'package:project2/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:project2/register_course_screen.dart';
import 'dart:convert';

import 'package:project2/util.dart';

class CourseScreen extends StatefulWidget {
  final User user;

  const CourseScreen({Key? key, required this.user}) : super(key: key);

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  Future<List<Course>> fetchCourses() async {
    final response = await http.get(Uri.https(firebaseUrl, 'courses.json'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<Course> courses = [];

      data.forEach((key, value) {
        Course course = Course(
          value['Course Name'],
          value['Date'],
          value['Time'],
          value['Categories'],
          value['Description'],
        );

        courses.add(course);
      });

      return courses;
    } else {
      throw Exception('Failed to load courses');
    }
  }

  void registerCourse(Course course) async {
    try {
      final response = await http.post(
        Uri.https(
          firebaseUrl,
          'users/${widget.user.userId}/registeredCourses.json',
        ),
        body: json.encode(
          {
            'courseName': course.courseName,
            'date': course.date,
            'time': course.time,
            // Add more fields as needed
          },
        ),
      );
      if (response.statusCode == 200) {
        print("Course registered successfully");
      } else {
        print("Failed to register course");
      }
    } catch (error) {
      print("#Debug course_screen.dart => Error = $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Course Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisterCourseScreen(
                    user: widget.user,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Course>>(
        future: fetchCourses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No courses available.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Course Name: ${snapshot.data![index].courseName}'),
                        Text('Date: ${snapshot.data![index].date}'),
                        Text('Time: ${snapshot.data![index].time}'),
                        Text('Categories: ${snapshot.data![index].courseCategories}'),
                        Text('Description: ${snapshot.data![index].courseDescription}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        registerCourse(snapshot.data![index]);
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
