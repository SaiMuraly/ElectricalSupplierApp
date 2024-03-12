import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _phonenumController;
  late TextEditingController _addressController;
  late TextEditingController _emailController;

  late Future<Database> _database;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _phonenumController = TextEditingController();
    _addressController = TextEditingController();
    _emailController = TextEditingController();

    // Initialize the database when the widget is initialized
    _database = initializeDatabase();
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = dir + "/tablex.db";

    // Open the database only if it hasn't been opened yet
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE usersdtl (
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

  // Function to register a new user
  Future<void> _registerUser(String username, String password, String phonenum, String address, String email) async {
    final db = await _database;

    await db.insert(
      'usersdtl',
      {'username': username, 'password': password, 'phonenum': phonenum, 'address': address, 'email': email},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print('User registered successfully');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FutureBuilder<Database>(
            future: _database,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                return Column(
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
                    TextField(
                      controller: _phonenumController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                      ),
                    ),
                    TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                      ),
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        String username = _usernameController.text;
                        String password = _passwordController.text;
                        String phonenum = _phonenumController.text;
                        String address = _addressController.text;
                        String email = _emailController.text;

                        // Register the user
                        await _registerUser(username, password, phonenum, address, email);

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Success'),
                              content: Text('User registered successfully.'),
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
                      },
                      child: Text('Register'),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Don't need to manually close the database here
    _usernameController.dispose();
    _passwordController.dispose();
    _phonenumController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
