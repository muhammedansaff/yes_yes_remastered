import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yes_yes/app/app.router.dart';

class LoginViewModel extends BaseViewModel {
  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  final String _locality = '';
  String get locality => _locality;

  final String _postalCode = '';
  String get postalCode => _postalCode;

  final String _sublocal = '';
  String get sublocal => _sublocal;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FocusNode emailFocusNode = FocusNode(); // Declare the FocusNode
  final FocusNode passwordFocusNode = FocusNode();

  bool _isChecked = false;
  bool get isChecked => _isChecked;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void onRememberMeChanged(bool? value) {
    _isChecked = value ?? false;
    notifyListeners();
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

  Future<void> onLoginPressed() async {
    if (!formKey.currentState!.validate()) return;

    _isLoading = true;
    notifyListeners();

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Check if email is verified
      if (userCredential.user != null && userCredential.user!.emailVerified) {
        // Email is verified, navigate to the main screen
        NavigationService().pushNamedAndRemoveUntil(Routes.botoomNav);
      } else {
        // Email is not verified, prompt the user to verify their email
        await DialogService().showDialog(
          title: 'Email Not Verified',
          description: 'Please verify your email to continue.',
          buttonTitle: 'Resend Verification Email',
        );

        // Optionally, you can resend the verification email here
        await userCredential.user?.sendEmailVerification();
        DialogService().showDialog(
          title: 'Verification Email Sent',
          description:
              'A new verification email has been sent. Please check your inbox.',
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle different login errors
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided.';
      } else {
        errorMessage = 'Something went wrong. Please try again.';
      }

      // Show error using Stacked's DialogService or any preferred way
      DialogService().showDialog(
        title: 'Login Error',
        description: errorMessage,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void navigateToSignUp() {
    NavigationService().replaceWith(Routes.signupScreen);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose(); // Dispose of the FocusNode
    passwordFocusNode.dispose(); // Dispose of the FocusNode
    super.dispose();
  }
}
