
class UserModel {
  final String id;
  final String? name;
  final String? email;
  final String? usn;

  UserModel({
    required this.id,
    this.name,
    this.email,
    this.usn,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'usn': usn,
    };
  }

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      usn: map['usn'],
    );
  }

}
