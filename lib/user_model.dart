class UserModel {
  final String id;
  final String? name;
  final String? email;
  final String? usn;
  final String? profileImageUrl;  // Added for profile picture URL

  UserModel({
    required this.id,
    this.name,
    this.email,
    this.usn,
    this.profileImageUrl,  // Initialize in constructor
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'usn': usn,
      'profileImageUrl': profileImageUrl,  // Add to map
    };
  }

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      usn: map['usn'],
      profileImageUrl: map['profileImageUrl'],  // Add from map
    );
  }
}
