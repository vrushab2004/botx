import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_model.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> registerWithEmailAndPassword(String email, String password, String fullName, BuildContext context) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user!;
      await _db.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'fullName': fullName,
        'email': email,
        'usn': '',
        'profileImageUrl': '',
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration successful')));
      Navigator.pushReplacementNamed(context, '/loginScreen');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration failed: ${e.toString()}')));
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password, BuildContext context, void Function(String) showSnackBar) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      showSnackBar('Login successful');
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      showSnackBar('Login failed: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  UserModel? get user {
    User? firebaseUser = _auth.currentUser;
    return firebaseUser != null ? UserModel(id: firebaseUser.uid, email: firebaseUser.email) : null;
  }

  Stream<UserModel?> get userStream {
    return _auth.authStateChanges().map((User? firebaseUser) {
      return firebaseUser != null ? UserModel(id: firebaseUser.uid, email: firebaseUser.email) : null;
    });
  }

  Future<UserModel?> getUserDetails() async {
    try {
      User? firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        DocumentSnapshot<Map<String, dynamic>> userDoc = await _db.collection('users').doc(firebaseUser.uid).get();
        if (userDoc.exists) {
          return UserModel.fromMap(userDoc.data()!);
        } else {
          print("User document does not exist.");
        }
      } else {
        print("No authenticated user.");
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
    return null;
  }

  Future<bool> checkIfEmailExists(String email) async {
    final result = await _db.collection('users').where('email', isEqualTo: email).get();
    return result.docs.isNotEmpty;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("Error sending password reset email: $e");
    }
  }
}
