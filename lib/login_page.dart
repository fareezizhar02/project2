import 'package:flutter/material.dart';
import 'package:project2/model/user.dart';
import 'package:project2/util.dart';
import 'home_screen.dart';
import 'signup_page.dart'; // Import your sign-up page
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void loginUser() async {
    final url = Uri.https(firebaseUrl, 'users.json');
    List<User> users = [];
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> usersJson = json.decode(response.body);

        for (final tempUsers in usersJson.entries) {
          users.add(
            User(
                userId: tempUsers.key.toString(),
                username: tempUsers.value['username'].toString(),
                email: tempUsers.value['email'].toString(),
                password: tempUsers.value['password'].toString()),
          );
          print(
              "#Debug login_page.dart -> key for users = ${tempUsers.value['username']}");
        }
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error login_page.dart loading items: $error');
    }
    late User loggedInUser;
    bool check = false;
    for (final user in users) {
      if (_usernameController.text == user.username &&
          _passwordController.text == user.password) {
        print("#Debug login_page.dart => user logged in");
        check = true;
        loggedInUser = user;
        break;
      }
    }
    if (check) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) {
        return HomeScreen(
          user: loggedInUser,
        );
      })));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('username or password might be wronge '),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'username'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                loginUser();
                // Perform basic login (username and password validation)
                // if (_usernameController.text == 'admin' && _passwordController.text == 'admin') {
                //   Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(builder: (context) => HomeScreen()),
                //   );
                // } else {
                //   // Show an error message for incorrect credentials
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(
                //       content: Text('Incorrect username or password'),
                //       duration: Duration(seconds: 2),
                //     ),
                //   );
                // }
              },
              child: Text('Login'),
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: () {
                // Navigate to the sign-up screen when "Sign Up" is clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              child: Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/**
 * 
 * 
 * void _loginUser()async{
    
    late User registeredUser;
    bool checkLogin = false;
    if(users.isNotEmpty){
      for(final tempUser in users){
        if(tempUser.email == _email && tempUser.password == _password){
          registeredUser = tempUser;
          checkLogin = true;
        }
      }
    }
    if(checkLogin){
      setState(() {
        loading = false;
      });
      print("#Debug Login_page.dart=>  user Loged in");
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (ctx){
            return HomePage(user: registeredUser);
          }), (route) => false);
    }else{
      setState(() => loading = false);
      print( "#Debug login_page.dart -> User is not in the database");

    }
  }
 */
