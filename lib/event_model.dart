import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String eventName;
  String speakerName;
  String stageName;
  String stageCapacity;
  DateTime? dateTime;
  String description;
  String? imageUrl;
  String creatorId; // Add the creatorId field

  EventModel({
    required this.eventName,
    required this.speakerName,
    required this.stageName,
    required this.stageCapacity,
    required this.dateTime,
    required this.description,
    this.imageUrl,
    required this.creatorId, // Require creatorId in the constructor
  });

  // Convert EventModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'eventName': eventName,
      'speakerName': speakerName,
      'stageName': stageName,
      'stageCapacity': stageCapacity,
      'dateTime': dateTime != null ? Timestamp.fromDate(dateTime!) : null,
      'description': description,
      'imageUrl': imageUrl,
      'creatorId': creatorId, // Include creatorId in the map
    };
  }

  // Create EventModel from a Map
  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      eventName: map['eventName'],
      speakerName: map['speakerName'],
      stageName: map['stageName'],
      stageCapacity: map['stageCapacity'],
      dateTime: map['dateTime'] != null ? (map['dateTime'] as Timestamp).toDate() : null,
      description: map['description'],
      imageUrl: map['imageUrl'],
      creatorId: map['creatorId'], // Read creatorId from the map
    );
  }
}
