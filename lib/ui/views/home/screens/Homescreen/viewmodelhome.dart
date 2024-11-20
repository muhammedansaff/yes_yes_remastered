import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class ViewmodelHome extends BaseViewModel {
  // Location related properties
  Position? _currentPosition;
  String _locality = '';
  String _postalCode = '';
  String _sublocal = '';
  String _address = '';
  String _error = '';

  Position? get currentPosition => _currentPosition;
  String get locality => _locality;
  String get postalCode => _postalCode;
  String get sublocal => _sublocal;
  String get address => _address;
  String get err => _error;

  // Checkbox state variables
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  bool isChecked4 = false;
  bool isLoading1 = false;
  bool isLoading3 = false;
  bool isLoading2 = false;
  bool isloading4 = false;
  // Properties to hold username, date, and month
  String? _currentuserid;
  String? _currentUsername = '';
  String? _currentDate;
  String? _currentMonth;
  String? get currentUsername => _currentUsername;
  String? get currentuserid => _currentuserid;
  String? get currentDate => _currentDate;
  String? get currentMonth => _currentMonth;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  // Methods to toggle checkboxes
  void toggleCheckbox1(bool? value) {
    isChecked1 = value ?? false;
    notifyListeners();
  }

  void toggleCheckbox2(bool? value) {
    isChecked2 = value ?? false;
    notifyListeners();
  }

  void toggleCheckbox4(bool? value) {
    isChecked4 = value ?? false;
    notifyListeners();
  }

  void toggleCheckbox3(bool? value) {
    isChecked3 = value ?? false;
    notifyListeners();
  }
  // Initial loading state

  // Other existing properties and methods

  String? currentmonth;

  // Variables to store fetched values
  // bool? leave = false;
  // bool? morning = false;
  // bool? afternoon = false;
  // bool? evening = false;

  // Function to fetch attendance values
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<Map<String, bool>> get attendanceStream async* {
    String? uid = _auth.currentUser?.uid;
    if (uid == null) return;

    _currentuserid = uid;
    if (uid != null) {
      _isLoading = true;
      notifyListeners(); // Notify listeners about loading completion
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        _currentUsername = data['fullName'] as String?;
      }
    }
    final docRef = _firestore
        .collection('attendance')
        .doc(uid)
        .collection('present days')
        .doc(DateFormat('MMMM').format(DateTime.now()))
        .collection(DateFormat('yyyy').format(DateTime.now()))
        .doc(DateFormat('dd-MM-yyyy').format(DateTime.now()));

    // Indicate that loading has started

    // Listen for changes in Firestore
    await for (var snapshot in docRef.snapshots()) {
      // Indicate loading has completed on the first snapshot received
      _isLoading = false;
      notifyListeners(); // Notify listeners about loading completion

      if (snapshot.exists && snapshot.data() != null) {
        yield {
          'slot1': snapshot['slot1'] ?? false,
          'slot2': snapshot['slot2'] ?? false,
          'slot3': snapshot['slot3'] ?? false,
          'slot4': snapshot['slot4'] ?? false,
          'leave': snapshot['leave'] ?? false,
        };
      } else {
        yield {
          'slot1': false,
          'slot2': false,
          'slot3': false,
          'slot4': false,
          'leave': false,
        };
      }
    }
  }

  Future<void> initializeData() async {
    // Simulate loading delay

    // Fetch user and location data
    await fetchUserAndDateDetails();

    await saveAttendance();
    // After data is fetched, set loading to false
    //await fetchAttendanceValues();
    //number of days
  }

  // Fetch location and address
  Future<void> fetchLocationAndAddress() async {
    setBusy(true);
    try {
      // Get current location
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('Location services are disabled.');

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied)
          throw Exception('Location permissions are denied.');
      }
      if (permission == LocationPermission.deniedForever)
        throw Exception('Location permissions are permanently denied.');

      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (_currentPosition != null) {
        print('Current Latitude: ${_currentPosition!.latitude}');
        print('Current Longitude: ${_currentPosition!.longitude}');
        // Fetch reverse geocoding address using Geoapify API
        var url = Uri.parse(
            'https://api.geoapify.com/v1/geocode/reverse?lat=${_currentPosition!.latitude}&lon=${_currentPosition!.longitude}&apiKey=aaba96040a304556aeac241e135cbd4f');
        var response = await http.get(url);
        if (response.statusCode == 200) {
          var result = json.decode(response.body);
          _address =
              result['features'][0]['properties']['city'] ?? 'No address found';
          _locality = result['features'][0]['properties']['state_district'] ??
              'No address found';

          print('Address: $_address');
          print('Locality: $_locality');

          notifyListeners();
        } else {
          print('Request failed with status: ${response.statusCode}.');
        }
      }
    } catch (e) {
      print('Error fetching location or reverse geocoding: $e');
      _error = e.toString();
      notifyListeners();
    } finally {
      setBusy(false);
    }
  }

  // Fetch the username, current date, and current month
  Future<void> fetchUserAndDateDetails() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    _currentuserid = uid;
    if (uid != null) {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        _currentUsername = data['fullName'] as String?;
      }
    }
    _currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    print(_currentDate);
    _currentMonth = DateFormat('MMMM').format(DateTime.now());
    notifyListeners();
    print(_currentMonth);
    notifyListeners();
  }

  // Save attendance data to Firebase

  Future<void> saveAttendance() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        _currentUsername = data['fullName'] as String?;
      }
    }

    // Define the reference to the attendance document
    DocumentReference attendanceRef = FirebaseFirestore.instance
        .collection('attendance')
        .doc(uid)
        .collection('present days')
        .doc(DateFormat('MMMM').format(DateTime.now()))
        .collection(DateFormat('yyyy').format(DateTime.now()))
        .doc(DateFormat('dd-MM-yyyy').format(DateTime.now()));

    DocumentReference leavref = FirebaseFirestore.instance
        .collection('attendance')
        .doc(uid)
        .collection('calender')
        .doc(DateFormat('MMMM').format(DateTime.now()))
        .collection(DateFormat('yyyy').format(DateTime.now()))
        .doc(DateFormat('dd-MM-yyyy').format(DateTime.now()));

    // Check if the document already exists
    DocumentSnapshot attendanceDoc = await attendanceRef.get();
    if (attendanceDoc.exists) {
      // Document exists, so return early and do not overwrite the data
      print("Document already exists");
      return;
    } else {
      await attendanceRef.set({
        'slot1': false,
        'slot2': false,
        'slot3': false,
        'slot4': false,
        'leave': false,
      }, SetOptions(merge: true));
    }
    DocumentSnapshot leavdoc = await leavref.get();
    if (leavdoc.exists) {
      // Document exists, so return early and do not overwrite the data
      print("leave document already exists");
      return;
    }
    await leavref.set({'status': 'leave'}, SetOptions(merge: true));

    // Document does not exist, so set the data to false
    DocumentReference exampleleaveref = FirebaseFirestore.instance
        .collection('attendance')
        .doc(uid)
        .collection('calender')
        .doc(DateFormat('MMMM').format(DateTime.now()));

    DocumentSnapshot exampleleavedoc = await exampleleaveref.get();
    if (exampleleavedoc.exists) {
      // Document exists, so return early and do not overwrite the data
      print("leave document already exists");
      return;
    }
    await exampleleaveref.set(
        {'year': DateFormat('yyyy').format(DateTime.now())},
        SetOptions(merge: true));

    // Document does not exist, so set the data to false

    DocumentReference exmpleref = FirebaseFirestore.instance
        .collection('attendance')
        .doc(uid)
        .collection('present days')
        .doc(DateFormat('MMMM').format(DateTime.now()));
    DocumentSnapshot exampledoc = await exmpleref.get();
    if (exampledoc.exists) {
      // Document exists, so return early and do not overwrite the data
      print("example doc set succesfully");
      return;
    } else {
      await exmpleref.set(
        {
          'year': DateFormat('yyyy').format(DateTime.now()),
        },
      );
    }
  }

  Future<void> updateslot1(BuildContext context) async {
    isLoading1 = true;
    notifyListeners();

    await fetchLocationAndAddress();
    if (_currentuserid != null &&
        _currentDate != null &&
        _currentMonth != null) {
      DocumentReference attendanceRef = FirebaseFirestore.instance
          .collection('attendance')
          .doc(_currentuserid)
          .collection('present days')
          .doc(_currentMonth!)
          .collection(DateFormat('yyyy').format(DateTime.now()))
          .doc(_currentDate!);

      await attendanceRef.set({
        'slot1': isChecked1,
        'slot1 location': "$_address",
      }, SetOptions(merge: true));

      // Display Snackbar message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green, // Customize the color as needed
          content: Text('slot1 attendance marked successfully'),
        ),
      );
    } else {
      print('Error: Username, Date, or Month not found');
    }

    isLoading1 = false;
    notifyListeners();
    await calculateAndUpdateAttendance();
  }

  Future<void> updateslot2(BuildContext context) async {
    isLoading2 = true;
    notifyListeners();

    await fetchLocationAndAddress();

    try {
      if (_currentuserid != null &&
          _currentDate != null &&
          _currentMonth != null) {
        DocumentReference attendanceRef = FirebaseFirestore.instance
            .collection('attendance')
            .doc(_currentuserid)
            .collection('present days')
            .doc(_currentMonth!)
            .collection(DateFormat('yyyy').format(DateTime.now()))
            .doc(_currentDate!);

        await attendanceRef.set(
            {'slot2': isChecked2, 'slot2 location': "$_address"},
            SetOptions(merge: true));

        // Display Snackbar message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green, // Customize the color as needed
            content: Text('slot2 attendance marked successfully'),
          ),
        );
      } else {
        print('Error: Username, Date, or Month not found');
      }
    } catch (e) {
      print('Error updating slot 2: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red, // Customize the color as needed
          content: Text('Failed to mark afternoon attendance: $e'),
        ),
      );
    } finally {
      isLoading2 = false;
      notifyListeners();
    }
    await calculateAndUpdateAttendance();
  }

  Future<void> updateslot3(BuildContext context) async {
    isLoading3 = true;
    notifyListeners();

    await fetchLocationAndAddress();

    try {
      if (_currentuserid != null &&
          _currentDate != null &&
          _currentMonth != null) {
        DocumentReference attendanceRef = FirebaseFirestore.instance
            .collection('attendance')
            .doc(_currentuserid)
            .collection('present days')
            .doc(_currentMonth!)
            .collection(DateFormat('yyyy').format(DateTime.now()))
            .doc(_currentDate!);

        await attendanceRef.set(
            {'slot3': isChecked3, 'slot3 location': "$_address"},
            SetOptions(merge: true));

        // Display Snackbar message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green, // Customize the color as needed
            content: Text('slot3 attendance marked successfully'),
          ),
        );
      } else {
        print('Error: Username, Date, or Month not found');
      }
    } catch (e) {
      print('Error updating slot 3: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red, // Customize the color as needed
          content: Text('Failed to mark evening attendance: $e'),
        ),
      );
    } finally {
      isLoading3 = false;
      notifyListeners();
    }
    await calculateAndUpdateAttendance();
  }

  Future<void> updateslot4(BuildContext context) async {
    isloading4 = true;
    notifyListeners();

    await fetchLocationAndAddress();

    try {
      if (_currentuserid != null &&
          _currentDate != null &&
          _currentMonth != null) {
        DocumentReference attendanceRef = FirebaseFirestore.instance
            .collection('attendance')
            .doc(_currentuserid)
            .collection('present days')
            .doc(_currentMonth!)
            .collection(DateFormat('yyyy').format(DateTime.now()))
            .doc(_currentDate!);

        await attendanceRef.set(
            {'slot4': isChecked4, 'slot4 location': "$_address"},
            SetOptions(merge: true));

        // Display Snackbar message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green, // Customize the color as needed
            content: Text('slot4 attendance marked successfully'),
          ),
        );
      } else {
        print('Error: Username, Date, or Month not found');
      }
    } catch (e) {
      print('Error updating slot 3: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red, // Customize the color as needed
          content: Text('Failed to mark evening attendance: $e'),
        ),
      );
    } finally {
      isloading4 = false;
      notifyListeners();
    }
    await calculateAndUpdateAttendance();
  }
Future<void> updateAttendanceSlot(
    BuildContext context,
    int slotNumber,
    bool isChecked,
    String address,
    String currentMonth,
    String currentUserId,
    String currentDate,
    bool isLoadingFlag) async {

  // Set loading state
  isLoadingFlag = true;
  notifyListeners();

  // Fetch location and address
  await fetchLocationAndAddress();

  try {
    if (currentUserId != null && currentDate != null && currentMonth != null) {
      // Get the attendance document reference
      DocumentReference attendanceRef = FirebaseFirestore.instance
          .collection('attendance')
          .doc(currentUserId)
          .collection('present days')
          .doc(currentMonth)
          .collection(DateFormat('yyyy').format(DateTime.now()))
          .doc(currentDate);

      // Construct the slot key and location key dynamically
      String slotKey = 'slot$slotNumber';
      String locationKey = '$slotKey location';

      // Update attendance in Firestore
      await attendanceRef.set(
        {
          slotKey: isChecked,
          locationKey: address,
        },
        SetOptions(merge: true),
      );

      // Display success Snackbar message
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Attendance marked successfully'),
        ),
      );
    } else {
      print('Error: Username, Date, or Month not found');
    }
  } catch (e) {
    print('Error updating slot $slotNumber: $e');
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text('Failed to mark attendance: $e'),
      ),
    );
  } finally {
    // Set loading state to false
    isLoadingFlag = false;
    notifyListeners();
  }

  // Calculate and update attendance
  await calculateAndUpdateAttendance();
}

  Future<void> calculateAndUpdateAttendance() async {
    print("hello");
    if (_currentuserid == null ||
        _currentMonth == null ||
        _currentDate == null) {
      print('Error: Missing user, month, or date information');
      return;
    }

    // Reference to the collection of attendance for the current user and month
    CollectionReference attendanceCollection = FirebaseFirestore.instance
        .collection('attendance')
        .doc(_currentuserid)
        .collection('present days')
        .doc(_currentMonth!)
        .collection(DateFormat('yyyy').format(DateTime.now()));

    // Fetch all attendance documents for the month
    QuerySnapshot attendanceSnapshot = await attendanceCollection.get();

    String status = '';

    // Iterate through each day's attendance document
    for (var doc in attendanceSnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      // Extract attendance booleans
      bool slot1 = data['slot1'] ?? false;
      bool slot2 = data['slot2'] ?? false;
      bool slot3 = data['slot3'] ?? false;
      bool slot4 = data['slot4'] ?? false;

      // Calculate attendance for the day
      int presentSlots =
          [slot1, slot2, slot3, slot4].where((slot) => slot).length;

      if (presentSlots == 4) {
        status = 'full day';
      } else if (presentSlots == 3) {
        status = '3/4';
      } else if (presentSlots == 2) {
        status = 'half day';
      } else if (presentSlots == 1) {
        status = '1/4';
      } else {
        status = 'absent';
      }
    }

    // Update the status based on the attendance calculation
    DocumentReference statusRef = FirebaseFirestore.instance
        .collection('attendance')
        .doc(_currentuserid!)
        .collection('calender')
        .doc(DateFormat('MMMM').format(DateTime.now()))
        .collection(DateFormat('yyyy').format(DateTime.now()))
        .doc(_currentDate!);

    await statusRef.set({
      'status': status,
    }, SetOptions(merge: true));
  }
}
