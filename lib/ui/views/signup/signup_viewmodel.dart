import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yes_yes/app/app.router.dart';

class SignupViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();
  
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController createPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  FocusNode fullNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode createPasswordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();

  bool isLoading = false;

  String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full Name is required';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm Password is required';
    }
    if (value != createPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
Future<void> signUp(BuildContext context) async {
  if (validateFullName(fullNameController.text) == null &&
      validateEmail(emailController.text) == null &&
      validatePassword(createPasswordController.text) == null &&
      validateConfirmPassword(confirmPasswordController.text) == null) {
    isLoading = true;
    notifyListeners();

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: createPasswordController.text,
      );

      // Send email verification
      await userCredential.user?.sendEmailVerification();

      // Store user data in Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'fullName': fullNameController.text,
        'email': emailController.text,
        'isEmailVerified': false, // Track email verification status
      });

      await _firestore.collection('attendance').doc(userCredential.user?.uid).set({
        'fullName': fullNameController.text,
        'email': emailController.text,
      });

      // Show a dialog asking the user to verify their email
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Verify Your Email"),
            content: Text("A verification link has been sent to ${emailController.text}. Please check your inbox and verify your email before logging in."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  NavigationService().replaceWith(Routes.loginScreen);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );

    } catch (e) {
      // Handle sign-up error
      print("Error: ${e.toString()}");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

  void requestFocusOnFullName() {
    fullNameFocusNode.requestFocus();
  }

  void requestFocusOnEmail() {
    emailFocusNode.requestFocus();
  }

  void requestFocusOnCreatePassword() {
    createPasswordFocusNode.requestFocus();
  }

  void requestFocusOnConfirmPassword() {
    confirmPasswordFocusNode.requestFocus();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    createPasswordController.dispose();
    confirmPasswordController.dispose();
    fullNameFocusNode.dispose();
    emailFocusNode.dispose();
    createPasswordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }
}
