class EventDetails {
  final String id;
  final String eventName;
  final String? speakerName;
  final DateTime? dateTime;
  final String? stageName;
  final String? stageCapacity;
  final String description;
  final String? image;
  final String creatorId; // Make sure this is non-nullable

  EventDetails({
    required this.id,
    required this.eventName,
    this.speakerName,
    this.dateTime,
    this.stageName,
    this.stageCapacity,
    required this.description,
    this.image,
    required this.creatorId, // Ensure this is required
  });
}
