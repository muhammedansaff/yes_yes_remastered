import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class Forgetviewmodel extends BaseViewModel {
  bool _isChecked = false;
  bool get isChecked => _isChecked;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
FocusNode forgotpasswordnode = FocusNode();
  void onRememberMeChanged(bool? value) {
    _isChecked = value ?? false;
    notifyListeners();
  }

  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Future<void> resetPassword(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      _isLoading = true;
      notifyListeners();
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Password reset email sent')),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message}')),
        );
      } finally {
        _isLoading = false;
        notifyListeners();
        emailController.clear();
      }
    }
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.clear();
  }
}
