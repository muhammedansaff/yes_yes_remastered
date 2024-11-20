import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yes_yes/app/app.router.dart';
import 'package:yes_yes/constants/utils.dart';
import 'package:yes_yes/services/example_service.dart';
import 'package:yes_yes/ui/refactored/attendencetile.dart';
import 'package:yes_yes/ui/refactored/button.dart';
import 'package:yes_yes/ui/views/home/screens/Homescreen/calender.dart';
import 'package:yes_yes/ui/views/home/screens/Homescreen/viewmodelhome.dart';


class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  bool? slot1 = null; // Initialize to false
  bool? slot2 = null; // Initialize to false
  bool? slot3 = null; // Initialize to false
  bool? slot4 = null;
  bool leave = true; // Initialize to false
  bool present = false;
  bool loading = true;
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    String currentmonth = DateFormat('MMMM').format(DateTime.now());

    // Get the current time
    DateTime now = DateTime.now();
    bool isAfter6PM = now.hour >= 23;
    bool isslottime1 = now.hour >= 11;
    bool isslottime2 = now.hour >= 13;
    bool isslottime3 = now.hour >= 15;
    bool isslottime4 = now.hour >= 18;
    return ViewModelBuilder<ViewmodelHome>.reactive(
      viewModelBuilder: () => ViewmodelHome(),
      onViewModelReady: (viewModel) async {
        viewModel.initializeData();
        viewModel.attendanceStream.listen((attendanceData) {
          // Check if attendanceData is null or empty

          if (attendanceData != null) {
            slot1 = attendanceData['slot1'] ?? false;
            slot2 = attendanceData['slot2'] ?? false;
            slot3 = attendanceData['slot3'] ?? false;
            slot4 = attendanceData['slot4'] ?? false;
            leave = attendanceData['leave'] ?? false;
            present = slot1! && slot2! && slot3! && slot4!;
            print('slot1:$slot1');
            print('slot2:$slot2');
            print('alot3:$slot3');
            print('slot4:$slot4');
            print('leave:$leave');
          } else {
            print('No attendance data available.');
          }
        });
      },
      builder: (BuildContext context, ViewmodelHome viewModel, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            title: Text("Mark Your Attendance",
                style: TextStyle(color: secondarycolor)),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.calendar_month, color: secondarycolor),
                onPressed: () {
                  Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        AttendanceCalendar(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0); // Slide in from the right
                      const end = Offset.zero;
                      const curve = Curves.easeInOut;

                      final tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      final offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                    transitionDuration: Duration(
                        milliseconds: 1200), // Slow down the transition
                  ));
                },
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
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(bottom: 24.0),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        color: Colors.white,
                      ),
                      child: (slot1 == null ||
                              slot2 == null ||
                              slot3 == null ||
                              slot4 == null)
                          ? Center(child: CircularProgressIndicator())
                          : isAfter6PM
                              ? Center(
                                  child: !present
                                      ? Text(
                                          'Cannot mark attendance after 6 PM',
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        )
                                      : Text(
                                          'you have marked all of your attendence ',
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ))
                              : Column(
                                  children: [
                                    const SizedBox(height: 15),

                                    // Slot 1 logic
                                    Attendencetile(
                                      textslot: "Slot 1",
                                      checkboxType: 1,
                                      slot1: viewModel.isChecked1,
                                      isTimePassed:
                                          isslottime1, // Check if time has passed
                                      isAttendanceMarked: slot1 ??
                                          false, // Check if attendance is marked
                                      onChanged: viewModel.toggleCheckbox1,
                                      buttonwidget: viewModel.isChecked1
                                          ? (viewModel.isLoading1
                                              ? CircularProgressIndicator(
                                                  color: primaryColor)
                                              : MyButton(
                                                  onPressed: () {
                                                    viewModel
                                                        .updateslot1(context);
                                                  },
                                                  text: "Post",
                                                  col: primaryColor,
                                                  textcolor: Colors.white,
                                                  isoutline: true,
                                                  height: 40,
                                                  width: 50,
                                                  texsize: 15,
                                                ))
                                          : const SizedBox(),
                                    ),

                                    // Slot 2 logic
                                    Attendencetile(
                                      textslot: "Slot 2",
                                      checkboxType: 2,
                                      slot2: viewModel.isChecked2,
                                      isTimePassed: isslottime2,
                                      isAttendanceMarked: slot2 ?? false,
                                      onChanged: viewModel.toggleCheckbox2,
                                      buttonwidget: viewModel.isChecked2
                                          ? (viewModel.isLoading2
                                              ? CircularProgressIndicator(
                                                  color: primaryColor)
                                              : MyButton(
                                                  onPressed: () {
                                                    viewModel
                                                        .updateslot2(context);
                                                  },
                                                  text: "Post",
                                                  col: primaryColor,
                                                  textcolor: Colors.white,
                                                  isoutline: true,
                                                  height: 40,
                                                  width: 50,
                                                  texsize: 15,
                                                ))
                                          : const SizedBox(),
                                    ),

                                    // Slot 3 logic
                                    Attendencetile(
                                      textslot: "Slot 3",
                                      checkboxType: 3,
                                      slot3: viewModel.isChecked3,
                                      isTimePassed: isslottime3,
                                      isAttendanceMarked: slot3 ?? false,
                                      onChanged: viewModel.toggleCheckbox3,
                                      buttonwidget: viewModel.isChecked3
                                          ? (viewModel.isLoading3
                                              ? CircularProgressIndicator(
                                                  color: primaryColor)
                                              : MyButton(
                                                  onPressed: () {
                                                    viewModel
                                                        .updateslot3(context);
                                                  },
                                                  text: "Post",
                                                  col: primaryColor,
                                                  textcolor: Colors.white,
                                                  isoutline: true,
                                                  height: 40,
                                                  width: 50,
                                                  texsize: 15,
                                                ))
                                          : const SizedBox(),
                                    ),

                                    // Slot 4 logic
                                    Attendencetile(
                                      textslot: "Slot 4",
                                      checkboxType: 4,
                                      slot4: viewModel.isChecked4,
                                      isTimePassed: isslottime4,
                                      isAttendanceMarked: slot4 ?? false,
                                      onChanged: viewModel.toggleCheckbox4,
                                      buttonwidget: viewModel.isChecked4
                                          ? (viewModel.isloading4
                                              ? CircularProgressIndicator(
                                                  color: primaryColor)
                                              : MyButton(
                                                  onPressed: () {
                                                    viewModel
                                                        .updateslot4(context);
                                                  },
                                                  text: "Post",
                                                  col: primaryColor,
                                                  textcolor: Colors.white,
                                                  isoutline: true,
                                                  height: 40,
                                                  width: 50,
                                                  texsize: 15,
                                                ))
                                          : const SizedBox(),
                                    ),
                                  ],
                                ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
