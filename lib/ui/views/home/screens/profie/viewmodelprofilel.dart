import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yes_yes/app/app.router.dart';

class Viewmodelprofile extends BaseViewModel {
  FirebaseAuth auth = FirebaseAuth.instance;
  void signout() {
    auth.signOut();
    NavigationService().pushNamedAndRemoveUntil(Routes.splash2);
  }

  Future<Map<String, dynamic>?> getUserData() async {
    // Get the current user's UID
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      // Reference to the Firestore document
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      // Check if the document exists
      if (userDoc.exists) {
        // Retrieve data from the document
        return userDoc.data() as Map<String, dynamic>?;
      }
    }

    return null; // Return null if no data found or user is not logged in
  }
}
