// Login Screen
import 'package:flutter/material.dart';
import 'package:managment/screens/home.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:managment/Screens/splashcreen.dart';
import 'package:managment/Screens/register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late Database _database;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = dir + "/tablex.db";

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE IF NOT EXISTS usersdtl (
            id INTEGER PRIMARY KEY,
            username TEXT,
            password TEXT,
            phonenum TEXT,
            address TEXT,
            email TEXT
          )
        ''');
      },
    );
  }

  // Function to authenticate user
  Future<bool> _authenticateUser(String username, String password) async {
    List<Map<String, dynamic>> result = await _database.query(
      'usersdtl',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty;
  }

  // Function to navigate to the destination screen
  void _goToDestination(BuildContext context) {
    String username = _usernameController.text;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SplashScreen(username1: username)),
    );
  }

  // Function to navigate to the registration screen
  void _goToRegistration(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String username = _usernameController.text;
                  String password = _passwordController.text;

                  bool isAuthenticated = await _authenticateUser(username, password);

                  if (isAuthenticated) {
                    _goToDestination(context);
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Invalid username or password.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text('Login'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  _goToRegistration(context); // Navigate to registration screen
                },
                child: Text('Sign Up'), // Add SignUp button
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _database.close();
    super.dispose();
  }
}