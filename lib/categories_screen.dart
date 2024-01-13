import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project2/model/user.dart';
import 'package:project2/util.dart';
import 'package:project2/model/course.dart';

class CategoriesScreen extends StatefulWidget {
  final User user;

  const CategoriesScreen({Key? key, required this.user}) :super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  void registerCourse(String course) async {
    try {
      final response = await http.post(
        Uri.https(
          firebaseUrl,
          'users/${widget.user.userId}/registeredCourses.json',
        ),
        body: json.encode(
          {
            'course': course,
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

  Future<Map<String, List<String>>> fetchCoursesByCategories() async {
    final response = await http.get(Uri.https(firebaseUrl, 'courses.json'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      Map<String, List<String>> categorizedCourses = {
        'Coding': [],
        'Cooking': [],
        'Mathematics': [],
      };

      data.forEach((key, value) {
        String category = value['Categories'];
        String courseName = value['Course Name'];

        if (categorizedCourses.containsKey(category)) {
          categorizedCourses[category]!.add(courseName);
        }
      });

      return categorizedCourses;
    } else {
      throw Exception('Failed to load courses');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, List<String>>>(
          future: fetchCoursesByCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No courses available.'));
            } else {
              return Column(
                children: [
                  _buildCategoryExpansionTile(
                    "Coding",
                    Icons.code,
                    Colors.red,
                    snapshot.data!['Coding']!,
                  ),
                  _buildCategoryExpansionTile(
                    "Cooking",
                    Icons.restaurant,
                    Colors.green,
                    snapshot.data!['Cooking']!,
                  ),
                  _buildCategoryExpansionTile(
                    "Mathematics",
                    Icons.calculate,
                    Colors.blue,
                    snapshot.data!['Mathematics']!,
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildCategoryExpansionTile(
      String title, IconData icon, Color color, List<String> courses) {
    return Card(
      elevation: 3,
      child: ExpansionTile(
        leading: Icon(icon, size: 40, color: color),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        children: courses.map((course) {
          return ListTile(
            title: Text(course),
            subtitle: Text("Subinfo"),
            trailing: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                registerCourse(course);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
