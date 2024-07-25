import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 Future<String> getUserFullName(String uid) async {
  try {
    if (uid.isEmpty || uid == 'unknown') {
      print('UID is empty or unknown.');
      return 'No Name'; // Default value if UID is not available or is 'unknown'
    }

    DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
    
    if (userDoc.exists) {
      return userDoc.get('fullName') ?? 'No Name'; // Fetch 'fullName' field
    } else {
      print('User document does not exist for UID: $uid');
      return 'No Name'; // Default if document does not exist
    }
  } catch (e) {
    print('Error fetching user data: $e');
    return 'Error'; // Default value in case of error
  }
}

Future<String> getCreatorFullName(String creatorId) async {
  try {
    if (creatorId.isEmpty || creatorId == 'unknown') {
      print('Creator ID is empty or unknown.');
      return 'No Name'; // Default value if creatorId is not available or is 'unknown'
    }

    DocumentSnapshot userDoc = await _firestore.collection('users').doc(creatorId).get();

    if (userDoc.exists) {
      return userDoc.get('fullName') ?? 'No Name'; // Fetch 'fullName' field
    } else {
      print('User document does not exist for Creator ID: $creatorId');
      return 'No User Data'; // Default if document does not exist
    }
  } catch (e) {
    print('Error fetching creator data: $e');
    return 'Error'; // Default value in case of error
  }
}
}
