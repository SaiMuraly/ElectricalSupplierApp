import 'package:flutter/material.dart';
import 'package:managment/Screens/add.dart';
import 'package:managment/Screens/home.dart';
import 'package:managment/Screens/statistics.dart';
import 'package:managment/Screens/profile.dart';
import 'package:kommunicate_flutter/kommunicate_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:managment/Screens/login.dart';
import 'package:managment/Screens/splashcreen.dart';

class Bottom extends StatefulWidget {
  final String username1; // Define username parameter
  const Bottom({Key? key, required this.username1}) : super(key: key);

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int index_color = 0;
  List<Widget> screens = [];

  @override
  void initState() {
    super.initState();
    screens = [
      Home(username1: widget.username1),
      Statistics(),
      ProfileScreen(username1: widget.username1),
    ];
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index_color],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Add_Screen()));
        },
        child: Icon(Icons.payment_outlined),
        backgroundColor: Color(0xff368983),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.only(top: 7.5, bottom: 7.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 0;
                  });
                },
                child: Icon(
                  Icons.home,
                  size: 30,
                  color: index_color == 0 ? Color(0xff368983) : Colors.grey,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 1;
                  });
                },
                child: Icon(
                  Icons.bar_chart_outlined,
                  size: 30,
                  color: index_color == 1 ? Color(0xff368983) : Colors.grey,
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  _launchURL('https://www.chatbase.co/chatbot-iframe/D3cG5eeloxrqv0mzyMe1F');
                },
                child: Icon(
                  Icons.message,
                  size: 30,
                  color: Colors.grey,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 2;
                  });
                },
                child: Icon(
                  Icons.person_outlined,
                  size: 30,
                  color: index_color == 2 ? Color(0xff368983) : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void startKommunicateConversation() {
    dynamic conversationObject = {
      'appId': '30d7ce92d71360c2f91bf97860321afd6',
    };

    KommunicateFlutterPlugin.buildConversation(conversationObject)
        .then((clientConversationId) {
      print("Conversation builder success : " + clientConversationId.toString());
    }).catchError((error) {
      print("Conversation builder error : " + error.toString());
    });
  }
}
