import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:managment/Screens/login.dart'; // Import the destination screen
import 'package:sqflite/sqflite.dart';

class ProfileScreen extends StatefulWidget {
  final String username1; // Define the username parameter
  const ProfileScreen({Key? key, required this.username1}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>> _userDataFuture;
  late Future<Database> _databaseFuture;

  @override
  void initState() {
    super.initState();
    _databaseFuture = initializeDatabase();
    _userDataFuture = _fetchUserData();
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = dir + "/tablex.db";

    return openDatabase(
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

  Future<Map<String, dynamic>> _fetchUserData() async {
    final Database database = await _databaseFuture;

    // Query the user data from the usersdtl table
    List<Map<String, dynamic>> users = await database.query('usersdtl');

    // Return the user data (assuming there's only one user in the database)
    if (users.isNotEmpty) {
      return users.first;
    } else {
      // Return an empty map if no user found
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _userDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return Column(
                children: [
                  const SizedBox(height: 40),
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage('images/user.png'),
                  ),
                  const SizedBox(height: 20),
                  itemProfile(widget.username1, CupertinoIcons.person),
                  const SizedBox(height: 10),
                  itemProfile(snapshot.data!['phonenum'], CupertinoIcons.phone),
                  const SizedBox(height: 10),
                  itemProfile(snapshot.data!['address'], CupertinoIcons.location),
                  const SizedBox(height: 10),
                  itemProfile(snapshot.data!['email'], CupertinoIcons.mail),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      child: const Text('Logout'),
                    ),
                  )
                ],
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Center(child: Text('No user data available'));
            }
          },
        ),
      ),
    );
  }

  Widget itemProfile(String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 5),
            color: Colors.blueGrey.withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 10,
          )
        ],
      ),
      child: ListTile(
        title: Text(subtitle),
        leading: Icon(iconData),
        trailing: Icon(Icons.arrow_forward, color: Colors.grey.shade400),
        tileColor: Color(0xff368983),
      ),
    );
  }
}
