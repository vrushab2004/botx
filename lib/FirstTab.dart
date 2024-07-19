import 'dart:io';
import 'package:flutter/material.dart';

class EventDetails {
  final String eventName;
  final DateTime? dateTime;
  final String? speakerName;
  final String description;
  final String? stageName;
  final String? stageCapacity;
  final File? image;

  EventDetails({
    required this.eventName,
    required this.dateTime,
    required this.description,
    this.speakerName,
    this.stageName,
    this.stageCapacity,
    this.image,
  });
}

class FirstTab extends StatelessWidget {
  final List<EventDetails> events;

  const FirstTab({Key? key, required this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: ListView.builder(
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
                              image: FileImage(event.image!),
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
                            Text(
                              event.eventName,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              event.speakerName ?? 'Speaker name not set',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  event.dateTime != null
                                      ? '${event.dateTime!.day}/${event.dateTime!.month}/${event.dateTime!.year}'
                                      : 'Date not set',
                                  style: TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                                Text(
                                  event.dateTime != null
                                      ? '${event.dateTime!.hour}:${event.dateTime!.minute.toString().padLeft(2, '0')}'
                                      : 'Time not set',
                                  style: TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${event.stageName ?? 'Stage name not set'} (${event.stageCapacity ?? 'Capacity not set'})',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  ExpansionTile(
                    title: Text('View Description'),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(event.description),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
