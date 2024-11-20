import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:yes_yes/constants/utils.dart';
import 'package:yes_yes/services/example_service.dart';

class PayrollScreen extends StatefulWidget {
  const PayrollScreen({super.key});

  @override
  State<PayrollScreen> createState() => _PayrollScreenState();
}

class _PayrollScreenState extends State<PayrollScreen> {
  final ExampleService service = ExampleService();
  String? username;

  late DateTime _focusedDay;
  late DateTime _currentMonth;
  bool isloading = false;
  StreamSubscription<QuerySnapshot>? _attendanceSubscription;
  Map<DateTime, String> attendanceMap = {};
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  List<int> yearList = [2023, 2024]; // Example years, adjust as needed
  List<int> monthList = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12
  ]; // January to December
  int? selectedYear;
  int? selectedMonth;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
    selectedYear = _currentMonth.year;
    selectedMonth = _currentMonth.month;
    _fetchUserDetails();
  }

  void _fetchUserDetails() async {
    String? fetchedUsername = await service.fetchUserAndDateDetails();
    setState(() {
      username = fetchedUsername;
    });

    if (username != null) {
      _fetchAttendanceData(DateTime(selectedYear!, selectedMonth!));
    }
  }

  void _fetchAttendanceData(DateTime month) async {
    setState(() {
      isloading = true; // Show loading indicator
      attendanceMap = {}; // Clear existing data
    });

    String monthName = DateFormat('MMMM').format(month);
    String year = DateFormat('yyyy').format(month);

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

    // Fetch the monthMap to check if the selected month exists in the database
    Map<String, dynamic> monthMap = {};
    await FirebaseFirestore.instance
        .collection('attendance')
        .doc(uid)
        .collection('calender')
        .get()
        .then((snapshot) {
      for (var doc in snapshot.docs) {
        monthMap[doc.id] = doc.data(); // Store the months in the map
      }
    });

    // Check if the selected month exists in the monthMap
    if (!monthMap.containsKey(monthName)) {
      // If the selected month doesn't exist, stop the data fetch process
      setState(() {
        isloading = false; // Hide loading indicator
      });
      return;
    }

    // Fetch the year from the month document to check if the year exists
    var selectedMonthDoc = monthMap[monthName];
    String storedYear = selectedMonthDoc[
        'year']; // Assuming year is stored as a field in the month document

    if (storedYear != year) {
      // If the year in the document doesn't match the selected year, stop the data fetch process
      setState(() {
        isloading = false; // Hide loading indicator
      });
      return;
    }

    // If the month and year exist, proceed with fetching data
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
        DateTime date = DateFormat('dd-MM-yyyy').parse(doc.id);
        String status = doc['status'];
        tempMap[date] = status;
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

      if (mounted) {
        setState(() {
          attendanceMap = tempMap;
          isloading = false; // Hide loading indicator
        });
      }
    });
  }

  @override
  void dispose() {
    _attendanceSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int presentCount = 0;
    double leaveCount = 0;
    double halfday = 0;
    double Salary = 1000;
    int totalDays = DateTime(_focusedDay.year, _focusedDay.month + 1, 0).day;

    attendanceMap.forEach((date, status) {
      if (status == 'full day') {
        presentCount++;
      } else if (status == 'leave') {
        leaveCount++;
      } else if (status == 'half day') {
        halfday++;
      }
    });

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: FloatingActionButton(
            backgroundColor: primaryColor,
            child: const Icon(
              Icons.picture_as_pdf,
              color: Colors.white,
            ),
            onPressed: () {
              _fetchAttendanceData(DateTime(selectedYear!, selectedMonth!));
              _generatePDF(
                  presentCount, halfday, Salary, leaveCount, totalDays);
            }),
      ),
      appBar: AppBar(
        backgroundColor: primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: Text('Payroll', style: TextStyle(color: secondarycolor)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                _buildDropdownButton(
                  value: selectedYear,
                  items: yearList,
                  onChanged: (newYear) {
                    setState(() {
                      selectedYear = newYear;
                      _fetchAttendanceData(
                          DateTime(selectedYear!, selectedMonth!));
                    });
                  },
                ),
                const SizedBox(width: 16),
                // Month Dropdown with a custom design
                _buildDropdownButton(
                  value: selectedMonth,
                  items: monthList,
                  onChanged: (newMonth) {
                    setState(() {
                      selectedMonth = newMonth;
                      _fetchAttendanceData(
                          DateTime(selectedYear!, selectedMonth!));
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      extendBody: true,
      backgroundColor: primaryColor,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 400,
            color: primaryColor,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: Colors.white,
                  ),
                  child: isloading
                      ? const Center(
                          child:
                              const CircularProgressIndicator()) // Show loading
                      : attendanceMap.isEmpty
                          ? const Center(
                              child: Text(
                                  'No data records found')) // No data found
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  // Company details at the top left
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 40,
                                      ),
                                      Image.asset(
                                        'assets/logoo.png',
                                        width: 100,
                                        height: 80,
                                      ), // Adjust size as needed
                                      const SizedBox(width: 20),
                                      const Text(
                                        'Yes Yes Marketing',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 100),
                                  const Text(
                                    'Payroll Summary',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                      'Total Full Days: ${attendanceMap.values.where((status) => status == 'full day').length}'),
                                  Text(
                                      'Total Half Days: ${attendanceMap.values.where((status) => status == 'half day').length}'),
                                  Text(
                                      'Total Leaves: ${attendanceMap.values.where((status) => status == 'leave').length}'),
                                  Text(
                                      'Total Salary: \$${1000.0.toStringAsFixed(2)}'), // Adjust salary logic
                                ],
                              ),
                            ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _generatePDF(int fullDays, double totalHalfDays,
      double totalSalary, double leave, int totalDays) async {
    try {
      final pdf = pw.Document();

      // Load image as bytes
      final ByteData data = await rootBundle
          .load('assets/logoo.png'); // Replace with your PNG image path
      final Uint8List imageBytes = data.buffer.asUint8List();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(32),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Company details at the top left
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Image(pw.MemoryImage(imageBytes),
                          width: 100, height: 80), // Adjust size as needed
                      pw.SizedBox(width: 20),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Yes Yes Marketing',
                            style: pw.TextStyle(
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            '1234 Market Street',
                            style: const pw.TextStyle(fontSize: 14),
                          ),
                          pw.Text(
                            'City, State, ZIP',
                            style: const pw.TextStyle(fontSize: 14),
                          ),
                          pw.Text(
                            'Phone: (123) 456-7890',
                            style: const pw.TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 100),
                  pw.Text(
                    'Payroll Summary',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text('Total Full Days: $fullDays'),
                  pw.Text('Total Half Days: ${totalHalfDays.toInt()} '),
                  pw.Text('Total leaves Days: ${leave.toInt()}'),
                  pw.Text('Total Salary: \$${totalSalary.toStringAsFixed(2)}'),
                ],
              ),
            );
          },
        ),
      );

      // Display the PDF in a dialog or a new screen
      await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 16,
            child: Container(
              // width: double.infinity,
              height: 550, // Set a fixed height for the dialog
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Use min size for the column
                children: [
                  Text(
                    'Payroll PDF Preview',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: PdfPreview(
                      build: (format) => pdf.save(),
                      canChangePageFormat: false,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () async {
                          // Allow user to download the PDF
                          await Printing.sharePdf(
                            bytes: await pdf.save(),
                            filename:
                                'Payroll_${DateTime.now().toIso8601String()}.pdf',
                          );
                          Navigator.of(context).pop();
                        },
                        child: const Text('Download'),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      print('Error generating PDF: $e');
    }
  }
}

Widget _buildDropdownButton({
  required int? value,
  required List<int> items,
  required ValueChanged<int?> onChanged,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.7), // Light background for dropdown
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          offset: Offset(0, 4),
          blurRadius: 6,
        ),
      ],
    ),
    child: DropdownButton<int>(
      value: value,
      icon: Icon(Icons.arrow_drop_down, color: primaryColor),
      iconSize: 30,
      style: TextStyle(color: primaryColor),
      underline: SizedBox(),
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<int>>((int year) {
        return DropdownMenuItem<int>(
          value: year,
          child: Text(
            year.toString(),
            style: TextStyle(
              color: primaryColor,
              fontSize: 18,
            ),
          ),
        );
      }).toList(),
    ),
  );
}
