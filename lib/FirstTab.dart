import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'event_details.dart';
import 'user_service.dart'; // Import the UserService class
import 'ticket_model.dart'; // Import the Ticket model

class FirstTab extends StatefulWidget {
  FirstTab({Key? key, required this.events}) : super(key: key);

  final List<EventDetails> events;

  @override
  State<FirstTab> createState() => _FirstTabState();
}

class _FirstTabState extends State<FirstTab> {
  final UserService _userService = UserService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _deleteEvent(String eventId, String? imageUrl) async {
    try {
      // Delete from Firestore
      await _firestore.collection('events').doc(eventId).delete();

      // Delete image from Firebase Storage if it exists
      if (imageUrl != null) {
        final storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
        await storageRef.delete();
      }
    } catch (e) {
      print('Error deleting event: $e');
    }
  }

  Future<void> _reserveSeat(EventDetails event) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      // Handle case where user is not logged in
      return;
    }

    final ticketId = _firestore.collection('tickets').doc().id;

    // Add ticket to Firestore
    await _firestore.collection('tickets').doc(ticketId).set({
      'ticketId': ticketId,
      'eventId': event.id,
      'userId': userId,
      'eventImage': event.image ?? '',
      'speakerName': event.speakerName ?? '',
      'stageName': event.stageName ?? '',
      'userFullName': await _userService.getUserFullName(userId),
      'reservationDate': Timestamp.now(),
    });
  }

  Future<void> _unreserveSeat(String ticketId) async {
    // Remove ticket from Firestore
    await _firestore.collection('tickets').doc(ticketId).delete();
  }

  Future<String> _fetchCreatorName(String uid) async {
    try {
      return await _userService.getUserFullName(uid);
    } catch (e) {
      print('Error fetching creator name: $e');
      return 'Error'; // Return a default value in case of an error
    }
  }

  Future<List<String>> _fetchStudentsApplied(String eventId) async {
    try {
      final querySnapshot = await _firestore
          .collection('tickets')
          .where('eventId', isEqualTo: eventId)
          .get();

      List<String> studentNames = [];
      for (var doc in querySnapshot.docs) {
        studentNames.add(doc['userFullName']);
      }
      return studentNames;
    } catch (e) {
      print('Error fetching students applied: $e');
      return [];
    }
  }

  bool isSelected = false;
  String? selectedTicketId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No events available'));
          }

          final events = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>?; // Safely cast doc.data() to a Map
            return EventDetails(
              id: doc.id,
              eventName: data?['eventName'] ?? 'Unknown Event',
              speakerName: data?['speakerName'],
              dateTime: data?['dateTime'] != null
                  ? (data!['dateTime'] as Timestamp).toDate()
                  : null,
              stageName: data?['stageName'],
              stageCapacity: data?['stageCapacity'],
              description: data?['description'],
              image: data?['imageUrl'],
              creatorId: data?.containsKey('creatorId') == true ? data!['creatorId'] : 'unknown', // Check if creatorId exists
            );
          }).toList();

          final currentUser = FirebaseAuth.instance.currentUser;

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Card(
                margin: EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (event.image != null)
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(event.image!),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      event.eventName,
                                      style: GoogleFonts.aBeeZee(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    Spacer(),
                                    if (currentUser?.uid == event.creatorId) // Show delete button only for the event creator
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text('Confirm Delete'),
                                              content: Text('Are you sure you want to delete this event?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () async {
                                                    Navigator.of(context).pop();
                                                    await _deleteEvent(event.id, event.image);
                                                  },
                                                  child: Text('Delete'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Cancel'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        icon: Icon(Icons.delete, color: Colors.red, size: 25),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  event.speakerName ?? 'Speaker name not set',
                                  style: GoogleFonts.aBeeZee(
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      event.dateTime != null
                                          ? '${event.dateTime!.day}/${event.dateTime!.month}/${event.dateTime!.year}'
                                          : 'Date not set',
                                      style: GoogleFonts.aBeeZee(
                                          color: Colors.grey.shade500,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    ),
                                    Text(
                                      event.dateTime != null
                                          ? '${event.dateTime!.hour}:${event.dateTime!.minute.toString().padLeft(2, '0')}'
                                          : 'Time not set',
                                      style: GoogleFonts.aBeeZee(
                                          color: Colors.grey.shade500,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${event.stageName ?? 'Stage name not set'} (${event.stageCapacity ?? 'Capacity not set'})',
                                  style: GoogleFonts.aBeeZee(
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      ExpansionTile(
                        title: Text('View Description', style: GoogleFonts.aBeeZee(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 15),),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(event.description, style: GoogleFonts.aBeeZee(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 14),),
                          ),
                          FutureBuilder<String>(
                            future: _fetchCreatorName(event.creatorId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text('Loading creator name...'),
                                );
                              } else if (snapshot.hasError) {
                                return Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text('Error loading name'),
                                );
                              } else {
                                return Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    'Created by: ${snapshot.data}',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      if (currentUser?.uid == event.creatorId)
                        ExpansionTile(
                          title: Text('Students Applied', style: GoogleFonts.aBeeZee(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 15),),
                          children: [
                            FutureBuilder<List<String>>(
                              future: _fetchStudentsApplied(event.id),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Text('Loading students...'),
                                  );
                                } else if (snapshot.hasError) {
                                  return Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Text('Error loading students'),
                                  );
                                } else {
                                  final studentNames = snapshot.data ?? [];
                                  if (studentNames.isEmpty) {
                                    return Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Text('No students applied'),
                                    );
                                  } else {
                                    return Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: studentNames.map((name) => Text(name)).toList(),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      Container(
                        child: InputChip(
                          label: Text(isSelected ? 'Reserved' : 'Reserve a Seat'),
                          labelStyle: GoogleFonts.aBeeZee(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10),
                          backgroundColor: Colors.red,
                          onSelected: (bool value) async {
                            setState(() {
                              isSelected = value;
                            });

                            final userId = FirebaseAuth.instance.currentUser?.uid;

                            if (userId == null) {
                              // Handle case where user is not logged in
                              return;
                            }

                            if (value) {
                              // Reserve the seat
                              await _reserveSeat(event);
                            } else {
                              // Unreserve the seat
                              final tickets = await _firestore.collection('tickets')
                                  .where('eventId', isEqualTo: event.id)
                                  .where('userId', isEqualTo: userId)
                                  .get();

                              for (var doc in tickets.docs) {
                                await _unreserveSeat(doc.id);
                              }
                            }
                          },
                          selected: isSelected,
                          selectedColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
