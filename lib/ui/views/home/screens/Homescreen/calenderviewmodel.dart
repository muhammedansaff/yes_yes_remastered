import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:yes_yes/services/example_service.dart';

class Calenderviewmodel extends BaseViewModel {
  final ExampleService service = ExampleService();
  String? username;
  Map<DateTime, String> attendanceMap = {};
  late CalendarFormat calendarFormat;
  late DateTime selectedDay;
  late DateTime focusedDay;
  late DateTime currentMonth;
  late int currentMonthNumber;
  late int _currentyear;
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  StreamSubscription<QuerySnapshot>? _attendanceSubscription;
  bool isdataavailable = true;
  bool _isDisposed = false; // Flag to track if the view model is disposed

  void initState() {
    // Set the calendar format to show month view
    calendarFormat = CalendarFormat.month;

    // Set the selected day to today
    selectedDay = DateTime.now();

    // Set the focused day to today
    focusedDay = DateTime.now();

    // Set the current month to the first day of the current month
    currentMonth = DateTime(DateTime.now().year, DateTime.now().month);

    _currentyear = DateTime.now().year;
    // Get the current month's number (1 = January, 2 = February, ..., 11 = November)
    currentMonthNumber = DateTime.now().month;

    // Optionally, you can print the month number to verify
    print('Current Month Number: $_currentyear');

    // Fetch user details (you can modify this based on your logic)
    _fetchUserDetails();
  }

  void _fetchUserDetails() async {
    String? fetchedUsername = await service.fetchUserAndDateDetails();

    username = fetchedUsername;
    notifyListeners();

    if (username != null) {
      _fetchAttendanceData(currentMonth);
    }
  }

  void _fetchAttendanceData(DateTime month) async {
    String monthName = DateFormat('MMMM').format(month);
    String year = DateFormat('yyyy').format(month);

    // Clear the map to avoid mixing data from different months
    attendanceMap = {};
    isdataavailable =
        false; // Initially set to false, before attempting to fetch data
    notifyListeners();

    try {
      // Check if the month exists in the database
      DocumentSnapshot monthDoc = await FirebaseFirestore.instance
          .collection('attendance')
          .doc(uid)
          .collection('calender')
          .doc(monthName)
          .get();

      if (!monthDoc.exists) {
        // If the month doesn't exist, log and return
        print("Month document '$monthName' does not exist in Firestore.");

        isdataavailable = false; // No data available if document doesn't exist
        notifyListeners();
        return;
      }

      // Check if the collection with the selected year exists
      var yearCollection = await FirebaseFirestore.instance
          .collection('attendance')
          .doc(uid)
          .collection('calender')
          .doc(monthName)
          .collection(year)
          .get();

      // If the collection does not exist, log and return
      if (yearCollection.docs.isEmpty) {
        print("Year collection '$year' does not exist for month '$monthName'.");

        isdataavailable =
            false; // No data available if year collection doesn't exist
        notifyListeners();
        return;
      }

      // Get the full range of dates for the selected month
      DateTime firstDayOfMonth = DateTime(month.year, month.month, 1);
      DateTime lastDayOfMonth = DateTime(month.year, month.month + 1, 0);
      DateTime today = DateTime.now(); // Current date
      List<DateTime> fullDateRange = [];
      for (int i = 0;
          i <= lastDayOfMonth.difference(firstDayOfMonth).inDays;
          i++) {
        fullDateRange.add(firstDayOfMonth.add(Duration(days: i)));
      }

      // Listen to attendance data within the year collection
      _attendanceSubscription = FirebaseFirestore.instance
          .collection('attendance')
          .doc(uid)
          .collection('calender')
          .doc(monthName)
          .collection(year)
          .snapshots()
          .listen((snapshot) {
        Map<DateTime, String> tempMap = {};

        // Populate the map with fetched data
        for (var doc in snapshot.docs) {
          try {
            DateTime date = DateFormat('dd-MM-yyyy').parse(doc.id);
            String status = doc['status'];
            tempMap[date] = status;
          } catch (e) {
            print("Error parsing document '${doc.id}': $e");
          }
        }

        // Add missing dates with the status 'leave'
        for (DateTime date in fullDateRange) {
          if (!tempMap.containsKey(date)) {
            // Mark as leave only if it's in the past or today
            if (month.year == today.year && month.month == today.month) {
              if (!date.isAfter(today)) {
                tempMap[date] = 'leave';
              }
            } else {
              tempMap[date] = 'leave'; // For months other than the current
            }
          }
        }

        // Update the UI if not disposed
        if (!_isDisposed) {
          attendanceMap = tempMap;
          isdataavailable = true; // Set to true once data is available
          notifyListeners();
        }
      });
    } catch (e) {
      print("Error fetching attendance data for '$monthName': $e");

      isdataavailable = false; // If there's an error, mark as no data available
      notifyListeners();
    }
  }

  void onPageChanged(DateTime focusedDay) {
    this.focusedDay = focusedDay;
    currentMonth = DateTime(focusedDay.year, focusedDay.month);
    _fetchAttendanceData(currentMonth);
    notifyListeners();
  }

  @override
  void dispose() {
    // Mark the view model as disposed
    _isDisposed = true;

    // Cancel the Firestore subscription when the widget is disposed
    _attendanceSubscription?.cancel();
    super.dispose();
  }
}
