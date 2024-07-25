import 'package:cloud_firestore/cloud_firestore.dart';

class Ticket {
  final String ticketId;
  final String eventId;
  final String userId;
  final String eventImage;
  final String speakerName;
  final String stageName;
  final String userFullName;
  final Timestamp reservationDate;

  Ticket({
    required this.ticketId,
    required this.eventId,
    required this.userId,
    required this.eventImage,
    required this.speakerName,
    required this.stageName,
    required this.userFullName,
    required this.reservationDate,
  });

  // Convert Firestore document to Ticket object
  factory Ticket.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Ticket(
      ticketId: doc.id,
      eventId: data['eventId'] ?? '',
      userId: data['userId'] ?? '',
      eventImage: data['eventImage'] ?? '',
      speakerName: data['speakerName'] ?? '',
      stageName: data['stageName'] ?? '',
      userFullName: data['userFullName'] ?? '',
      reservationDate: data['reservationDate'] ?? Timestamp.now(),
    );
  }

  // Convert Ticket object to Firestore document data
  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'userId': userId,
      'eventImage': eventImage,
      'speakerName': speakerName,
      'stageName': stageName,
      'userFullName': userFullName,
      'reservationDate': reservationDate,
    };
  }
}
