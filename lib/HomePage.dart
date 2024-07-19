import 'package:tedz/theme/colors.dart';

import 'FirstTab.dart';
import 'OnGoing.dart';
import 'SecondTab.dart';
import 'addevent.dart' as addevent;
import 'completed.dart';
import 'login1.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<EventDetails> events = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 80,
              automaticallyImplyLeading: false,
              leading: Builder(builder: (context) {
                return GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(),
                  ),
                );
              }),
              title: Container(
                margin: EdgeInsets.only(top: 58, left: 47),
                child: Image.asset(
                  'assets/my.png',
                  height: 150,
                  color: const Color.fromARGB(255, 249, 234, 96),
                ),
              ),
              bottom: const TabBar(
                indicatorColor: Colors.amber,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 6,
                tabs: [
                  Tab(
                    icon: Icon(Icons.event, color: Colors.white),
                  ),
                  Tab(
                    icon: Icon(Icons.airplane_ticket, color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: CustomColors.buttoncolor,
            ),
            drawer: Drawer(
              surfaceTintColor: Colors.transparent,
              child: ListView(
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: CustomColors.buttoncolor,
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Profile',
                              style: GoogleFonts.aBeeZee(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 15),
                            ),
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.purple,
                              child: Container(
                                margin: EdgeInsets.only(top: 45, left: 49),
                                child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.add_a_photo_sharp,
                                      size: 20,
                                    )),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(padding: EdgeInsets.only(top: 60)),
                            Container(
                                margin: EdgeInsets.only(left: 20),
                                child: Text(
                                  'Name',
                                  style: GoogleFonts.aBeeZee(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                )),
                            Container(
                                margin: EdgeInsets.only(left: 20),
                                child: Text(
                                  'USN',
                                  style: GoogleFonts.aBeeZee(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'OnGoing',
                      style: GoogleFonts.aBeeZee(),
                    ),
                    leading: Icon(Icons.live_tv),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ongo()),
                      );
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Completed',
                      style: GoogleFonts.aBeeZee(),
                    ),
                    leading: Icon(Icons.star),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const complete()),
                      );
                    },
                  ),
                  ListTile(
                      title: Text(
                        'Sign-Out',
                        style: GoogleFonts.aBeeZee(),
                      ),
                      leading: Icon(Icons.exit_to_app),
                      onTap: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => Container(
                              margin: EdgeInsets.only(top: 150),
                              child: AlertDialog(
                                title: Center(
                                    child: Text(
                                  'Signing Out',
                                  style: GoogleFonts.aBeeZee(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                )),
                                content: Text(
                                  'Are you ready to sign-out ?',
                                  style: GoogleFonts.aBeeZee(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                backgroundColor: Colors.white,
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      _logout(context);
                                    },
                                    child: Text(
                                      'OK',
                                      style: GoogleFonts.aBeeZee(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Cancel',
                                      style: GoogleFonts.aBeeZee(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                  SizedBox(
                    height: 90,
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(left: 40, right: 40, top: 200),
                      child: ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const addevent.Addevent(),
                            ),
                          );

                          if (result != null && result is addevent.EventDetails) {
                            setState(() {
                              events.add(EventDetails(
                                eventName: result.eventName,
                                speakerName:result.speakerName,
                                dateTime: result.dateTime,
                                stageName:result.stageName,
                                stageCapacity:result.stageCapacity,
                                description: result.description,
                                image: result.image,
                              ));
                            });
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 30,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              Text(
                                'Create Event',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(CustomColors.buttoncolor)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                FirstTab(events: events),
                secondtab(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }
}
