import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'dart:typed_data'; // For web

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:yes_yes/services/example_service.dart';

class Viewmodelleave extends BaseViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  DateTime now = DateTime.now();
  final _reasonController = TextEditingController();
  DateTime? _selectedDate;
  io.File? _selectedImage;
  Uint8List? _webImage; // For web
  String? _selectedLeaveType;
  bool isLoading = false;
  TextEditingController get reasonController => _reasonController;
  DateTime? get selectedDate => _selectedDate;
  io.File? get selectedImage => _selectedImage;
  Uint8List? get webImage => _webImage;
  String? get selectedLeaveType => _selectedLeaveType;
  String? imageUrl;
  String? uid = FirebaseAuth.instance.currentUser?.uid;

  void pickDate(DateTime? date) {
    _selectedDate = date;
    notifyListeners();
  }

  void pickImage(io.File? image) {
    _selectedImage = image;
    notifyListeners();
  }

  void pickImageWeb(Uint8List? imageBytes) {
    _webImage = imageBytes;
    notifyListeners();
  }

  void setLeaveType(String? leaveType) {
    _selectedLeaveType = leaveType;
    notifyListeners();
  }

  Future<String> uploadImage(io.File image) async {
    try {
      final imageRef =
          _storage.ref().child('receipts/${DateTime.now().toString()}');
      await imageRef.putFile(image);
      String downloadUrl = await imageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Failed to upload image: $e');
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<String> uploadImageWeb(Uint8List imageBytes) async {
    try {
      final imageRef =
          _storage.ref().child('receipts/${DateTime.now().toString()}');
      await imageRef.putData(
          imageBytes, SettableMetadata(contentType: 'image/jpeg'));
      String downloadUrl = await imageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Failed to upload image: $e');
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<bool> submitLeaveApplication(
      String userId, BuildContext context) async {
    isLoading = true;
    notifyListeners();

    if (_selectedDate == null) {
      isLoading = false;
      notifyListeners();
      throw Exception('Date not selected');
    }
    if (_selectedLeaveType == null || _selectedLeaveType!.isEmpty) {
      isLoading = false;
      notifyListeners();
      throw Exception('Leave type not selected');
    }

    try {
      // ExampleService to fetch user details
      ExampleService service = ExampleService();
      String? username = await service.fetchUserAndDateDetails();

      // Ensure username is not null
      if (username == null) {
        throw Exception('Username not found');
      }

      // Reference to Firestore document
      String formattedDate = DateFormat('dd-MM-yyyy').format(_selectedDate!);

      // Check if leave document already exists for the selected date
      DocumentReference leaveDoc = _firestore
          .collection('attendance')
          .doc(uid)
          .collection('present days')
          .doc(DateFormat('MMMM').format(DateTime.now()))
          .collection(DateFormat('yyyy').format(DateTime.now()))
          .doc(formattedDate);

      // Fetch existing document
      DocumentSnapshot leaveDocSnapshot = await leaveDoc.get();

      if (leaveDocSnapshot.exists) {
        // Show snackbar if leave is already applied for the selected date
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You have already applied for leave on this date.'),
          ),
        );
        isLoading = false;
        notifyListeners();
        return false; // Indicate failure
      }

      // Data to be uploaded
      Map<String, dynamic> leaveData = {
        'reason': reasonController.text,
        'date': DateFormat('dd-MM-yyyy').format(_selectedDate!),
        'time': DateFormat('HH:mm:ss').format(DateTime.now()),
        'leaveType': _selectedLeaveType,
      };

      // Reference to attendance update document
      DocumentReference atteupd = _firestore
          .collection('attendance')
          .doc(uid)
          .collection('present days')
          .doc(DateFormat('MMMM').format(DateTime.now()))
          .collection(DateFormat('yyyy').format(DateTime.now()))
          .doc(formattedDate);

      // Data for attendance update
      Map<String, dynamic> attendata = {
        'leave': true,
        'slot1': false,
        'slot2': false,
        'slot3': false,
        'slot4': false,
      };

      // Reference to date document
      // DocumentReference datedoc = FirebaseFirestore.instance
      //     .collection(username)
      //     .doc(DateFormat('yyyy').format(DateTime.now()))
      //     .collection(DateFormat('MMMM').format(DateTime.now()))
      //     .doc(formattedDate);
      DocumentReference datedoc = FirebaseFirestore.instance
          .collection('attendance')
          .doc(uid)
          .collection('calender')
          .doc(DateFormat('MMMM').format(DateTime.now()))
          .collection(DateFormat('yyyy').format(DateTime.now()))
          .doc(formattedDate);
      // Data for date update
      Map<String, dynamic> datedata = {
        'status': 'leave',
      };

      // Handle image upload based on platform
      if (_selectedImage != null || _webImage != null) {
        try {
          String downloadUrl;
          if (kIsWeb && _webImage != null) {
            downloadUrl = await uploadImageWeb(_webImage!);
          } else if (_selectedImage != null) {
            downloadUrl = await uploadImage(_selectedImage!);
          } else {
            isLoading = false;
            notifyListeners();
            throw Exception('No image selected');
          }

          imageUrl = downloadUrl;
          notifyListeners();
          print('img: $imageUrl');
          leaveData['receiptUrl'] = imageUrl;
        } catch (e) {
          print('Failed to upload image: $e');
        }
      }

      // Set data to Firestore
      await leaveDoc.set(leaveData, SetOptions(merge: true));
      await atteupd.set(attendata, SetOptions(merge: true));
      await datedoc.set(datedata, SetOptions(merge: true));

      // Clear form
      _reasonController.clear();
      _selectedDate = null;
      _selectedImage = null;
      _webImage = null;
      _selectedLeaveType = null;
      notifyListeners();
      return true; // Indicate success
    } catch (e) {
      throw Exception('Failed to submit leave application: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
