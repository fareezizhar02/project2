class Course {
  final String courseName;
  final String date;
  final String time; 
  final String courseCategories;
  final String courseDescription;
  

  Course(this.courseName, this.date, this.time, this.courseCategories, this.courseDescription);
}

List<Course> courses = [
  Course('Course 1', '', '', '', 'Introduction to Flutter'),
  Course('Course 2', '', '', '', 'Web Development with React'),
  Course('Course 3', '', '', '', 'Mobile App Design Principles'),
];