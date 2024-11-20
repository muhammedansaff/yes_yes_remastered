import 'package:flutter/material.dart';

class Mytextfield extends StatelessWidget {
  final IconData? icon;
  final String hinttext;
  final String type;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  const Mytextfield({
    super.key,
    required this.focusNode,
    required this.icon,
    required this.hinttext,
    required this.type,
    this.controller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 62, right: 62),
      child: TextFormField(
        focusNode: focusNode,
        controller: controller,
        validator: validator,
        obscureText: type == "password", // Hides text for password fields
        decoration: InputDecoration(
          hintText: hinttext,
          hintStyle: const TextStyle(color: Colors.grey, fontFamily: "ansaf"),
          contentPadding: const EdgeInsets.only(top: 5),
          prefixIcon: Icon(icon, color: Colors.black),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
