import 'package:flutter/material.dart';
import 'package:project2/util.dart';
import 'login_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _usernameController = TextEditingController();
    TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
    TextEditingController _repasswordController = TextEditingController();


  void registerUser()async{
        final url = Uri.https(firebaseUrl, 'users.json');

         try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(
            {
              'username': _usernameController.text,
              'email': _emailController.text,
              'password': _passwordController.text,
            },
          ));

      if (response.statusCode == 200) {
        final Map<String, dynamic> registerUser = json.decode(response.body);
                print("#debug signup_page.dart => user name = ${registerUser['name']}");

      }
      }catch(error){
        print("#debug signup_page.dart => error $error ");
      }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _repasswordController,
                decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Perform sign-up logic here
                  if (_passwordController.text == _repasswordController.text) {
                    registerUser();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Password is not matched'),
                    ));
                  }
                },
                child: Text('Submit'),
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: () {
                  // Navigate to the login page when "Cancel" is clicked
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text(
                  'Cancel',
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
      ),
    );
  }
}

/**
 * 
 * 
 * void _registerUser() async {


    final url = Uri.https(firebaseUrl, 'users.json');
    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(
            {
              'username': "$firstName $lastName",
              'email': _email,
              'password': _password,
            },
          ));

      if (response.statusCode == 200) {
        final Map<String, dynamic> registerUser = json.decode(response.body);

        User user = User(
            userId: registerUser['name'],
            displayName: "$firstName $lastName",
            email: _email,
            password: _password);
        print("#Debug signup_page.dart -> username is '$firstName $lastName' ");
        print(
            "#Debug signup_page.dart -> userid is '${registerUser['name']}' ");
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) {
          return HomePage(user: user);
        }), (route) => false);
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        setState(() {
          _error = 'Failed to load data. Status code: ${response.statusCode}';
          loading = false;
        });
      }
    } catch (error) {
      print('Error loading items: $error');
      setState(() {
        _error = error.toString();
        loading = false;
      });
    }
  }
 */