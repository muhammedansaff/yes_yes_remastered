import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExampleService {
  String? currentUsername;

  Future<String?> fetchUserAndDateDetails() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        currentUsername = data['fullName'] as String?;
      }
    }
    
    // Return the fetched username
    return currentUsername;
  }
}
