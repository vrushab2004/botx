import 'dart:io';
import 'package:tedz/FirstTab.dart' as first_tab;
import 'package:tedz/theme/colors.dart';
import 'package:tedz/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'FirstTab.dart';
import 'OnGoing.dart';
import 'SecondTab.dart';
import 'addevent.dart' as addevent;
import 'completed.dart';
import 'event_details.dart' as event_model;  // Alias for EventDetails
import 'login1.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<event_model.EventDetails> events = [];
  final UserService _userService = UserService();
  final ImagePicker _picker = ImagePicker();
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    _fetchProfileImageUrl();
  }

Future<String> _fetchFullName() async {
  try {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    
    // Check if userId is valid
    if (userId.isEmpty) {
      print('No user is currently signed in.');
      return 'No Name'; // Default value if userId is not available
    }

    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    
    if (userDoc.exists) {
      return userDoc.get('fullName') ?? 'No Name'; // Use 'fullName' field
    } else {
      print('User document does not exist.');
      return 'No Name'; // Default if document does not exist
    }
  } catch (e) {
    print('Error fetching user data: $e');
    return 'Error'; // Default value in case of error
  }
}

  Future<void> _fetchProfileImageUrl() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (userId.isNotEmpty) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        if (userDoc.exists && userDoc.get('profileImageUrl') != null) {
          setState(() {
            profileImageUrl = userDoc.get('profileImageUrl');
          });
        }
      }
    } catch (e) {
      print('Error fetching profile image URL: $e');
    }
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        File imageFile = File(image.path);

        String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
        if (userId.isNotEmpty) {
          UploadTask uploadTask = FirebaseStorage.instance
              .ref('profile_images/$userId.png')
              .putFile(imageFile);

          TaskSnapshot taskSnapshot = await uploadTask;
          String downloadUrl = await taskSnapshot.ref.getDownloadURL();

          await FirebaseFirestore.instance.collection('users').doc(userId).update({
            'profileImageUrl': downloadUrl,
          });

          setState(() {
            profileImageUrl = downloadUrl;
          });
        }
      }
    } catch (e) {
      print('Error picking and uploading image: $e');
    }
  }

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
                    child: CircleAvatar(
                      backgroundImage: profileImageUrl != null ? NetworkImage(profileImageUrl!) : null,
                      child: profileImageUrl == null ? Icon(Icons.person) : null,
                    ),
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
                              backgroundImage: profileImageUrl != null ? NetworkImage(profileImageUrl!) : null,
                              child: Container(
                                margin: EdgeInsets.only(top: 45, left: 49),
                                child: IconButton(
                                  onPressed: _pickAndUploadImage,
                                  icon: Icon(
                                    Icons.add_a_photo_sharp,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
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
                                  'Hello !!',
                                  style: GoogleFonts.aBeeZee(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                )),
                            FutureBuilder<String>(
                              future: _fetchFullName(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text(
                                      'Loading...',
                                      style: GoogleFonts.aBeeZee(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text(
                                      'Error',
                                      style: GoogleFonts.aBeeZee(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  );
                                } else {
                                  return Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text(
                                      snapshot.data ?? 'No Name',
                                      style: GoogleFonts.aBeeZee(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  );
                                }
                              },
                            ),
                          
                          ],
                        ),
                      ],
                    ),
                  ),
                  // ListTile(
                  //   title: Text(
                  //     'OnGoing',
                  //     style: GoogleFonts.aBeeZee(),
                  //   ),
                  //   leading: Icon(Icons.live_tv),
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => const ongo()),
                  //     );
                  //   },
                  // ),
                  // ListTile(
                  //   title: Text(
                  //     'Completed',
                  //     style: GoogleFonts.aBeeZee(),
                  //   ),
                  //   leading: Icon(Icons.star),
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => const complete()),
                  //     );
                  //   },
                  // ),
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
                    height: 210,
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

                          if (result != null && result is event_model.EventDetails) {
                            setState(() {
                              events.add(event_model.EventDetails(
                                eventName: result.eventName,
                                speakerName: result.speakerName,
                                dateTime: result.dateTime,
                                stageName: result.stageName,
                                stageCapacity: result.stageCapacity,
                                description: result.description,
                                image: result.image, id: '', creatorId: '',
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
                                MaterialStateProperty.all(CustomColors.buttoncolor)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                FirstTab(events: events),
                SecondTab(),
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
