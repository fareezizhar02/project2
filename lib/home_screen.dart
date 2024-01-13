import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project2/course_screen.dart';
import 'package:project2/exam_results_screen.dart';
import 'package:project2/model/mycourses_screen.dart';
import 'package:project2/model/user.dart';
import 'categories_screen.dart';
import 'model/course.dart'; 
import 'schedule_screen.dart';
import 'login_page.dart'; // Import your login page



class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({super.key, required this.user});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;


  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _autoScroll();
    });
  }

  void _autoScroll() {
    if (_currentPage < courses.length - 1) {
      _currentPage++;
    } else {
      _currentPage = 0;
    }
    _pageController.animateToPage(
      _currentPage,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E-course App'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                widget.user.username,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                // Add your profile navigation logic here
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Exam Result'),
              onTap: () {
                // Add your exam result navigation logic here
                Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExamResultScreen()),
            );
              },
            ),
            ListTile(
              title: Text('Schedule'),
              onTap: () {
                // Add your schedule navigation logic here
                Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ScheduleScreen(user: widget.user,)),
            );
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                // Navigate to the login page when Logout is clicked
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false, // Clear the navigation stack
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Content Section
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for courses',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Navigation Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavigationBarItem('Categories', Icons.category),
                      _buildNavigationBarItem('Course', Icons.star),
                      _buildNavigationBarItem('My Courses', Icons.bookmark),
                      _buildNavigationBarItem('More', Icons.more_horiz),
                    ],
                  ),

                  SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Popular Course Section
          SizedBox(
            height: 200, // Set the desired height for the card
            child: PageView.builder(
              controller: _pageController,
              itemCount: courses.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return _buildPopularCourseCard(courses[index]);
              },
            ),
          ),
        ],
      ),) 
    );
  }

  Widget _buildPopularCourseCard(Course course) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              course.courseName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(course.courseDescription),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationBarItem(String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        if (title == 'Categories') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CategoriesScreen(user: widget.user,)),
          );
        } else if (title == 'Course') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CourseScreen(user: widget.user,)), // Replace CoursePage with your actual course page
          );
        } else if (title == 'My Courses') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyCourseScreen(user: widget.user)), // Replace CoursePage with your actual course page
          );
        } 
      },
      child: Column(
        children: [
          Icon(icon, size: 32),
          SizedBox(height: 4),
          Text(title),
        ],
      ),
    );
  }
}