import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:yes_yes/app/app.router.dart';
import 'package:yes_yes/constants/utils.dart';
import 'package:yes_yes/services/example_service.dart';
import 'package:yes_yes/ui/views/home/screens/Homescreen/calenderviewmodel.dart';
import 'package:yes_yes/ui/views/home/screens/Homescreen/viewmodelhome.dart';

class AttendanceCalendar extends StatefulWidget {
  @override
  _AttendanceCalendarState createState() => _AttendanceCalendarState();
}

class _AttendanceCalendarState extends State<AttendanceCalendar> {
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    String currentmonth = DateFormat('MMMM').format(DateTime.now());

    // Get the current time
    DateTime now = DateTime.now();

    return ViewModelBuilder<Calenderviewmodel>.reactive(
      viewModelBuilder: () => Calenderviewmodel(),
      onViewModelReady: (viewModel) async {
        viewModel.initState();
      },
      builder:
          (BuildContext context, Calenderviewmodel viewModel, Widget? child) {
        int presentCount = 0;
        int leaveCount = 0;
        int halfday = 0;
        int threequarter = 0;
        int quarter = 0;
        int totalDays = DateTime(
                viewModel.focusedDay.year, viewModel.focusedDay.month + 1, 0)
            .day;

        viewModel.attendanceMap.forEach((date, status) {
          if (status == 'full day') {
            presentCount++;
          } else if (status == '1/4') {
            quarter++;
          } else if (status == '3/4') {
            threequarter++;
          } else if (status == 'half day') {
            halfday++;
          } else if (status == 'leave') {
            leaveCount++;
          }
        });
        final screenHeight = MediaQuery.of(context).size.height;
        return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: primaryColor,
              title: Text("Attendance calender",
                  style: TextStyle(color: secondarycolor)),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: secondarycolor),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Stack(children: [
              Container(
                width: double.infinity,
                height: 400,
                color: primaryColor,
              ),
              Column(children: [
                SizedBox(
                  height: screenHeight * 0.02,
                ),
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
                  child: viewModel.username == null
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              TableCalendar(
                                firstDay: DateTime.utc(2024, 9, 1),
                                lastDay: DateTime.utc(2025,
                                    viewModel.currentMonthNumber, totalDays),
                                focusedDay: viewModel.focusedDay,
                                selectedDayPredicate: (day) =>
                                    isSameDay(viewModel.selectedDay, day),
                                calendarFormat: viewModel.calendarFormat,
                                onFormatChanged: (format) {
                                  setState(() {
                                    viewModel.calendarFormat = format;
                                  });
                                },
                                onDaySelected: (selectedDay, focusedDay) {
                                  setState(() {
                                    selectedDay = selectedDay;
                                    focusedDay = focusedDay;
                                  });
                                },
                                onPageChanged: (focusedDay) {
                                  viewModel.onPageChanged(focusedDay);
                                },
                                daysOfWeekStyle: const DaysOfWeekStyle(
                                  weekendStyle: TextStyle(color: Colors.red),
                                ),
                                calendarBuilders: CalendarBuilders(
                                  defaultBuilder: (context, day, focusedDay) {
                                    final date =
                                        DateTime(day.year, day.month, day.day);
                                    final status =
                                        viewModel.attendanceMap[date];

                                    if (status == 'leave') {
                                      return Container(
                                        margin: const EdgeInsets.all(4.0),
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${day.day}',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      );
                                    } else if (status == 'full day') {
                                      return Container(
                                        margin: const EdgeInsets.all(4.0),
                                        decoration: const BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${day.day}',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      );
                                    } else if (status == 'half day') {
                                      return Container(
                                        margin: const EdgeInsets.all(4.0),
                                        decoration: const BoxDecoration(
                                          color: Colors.grey,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${day.day}',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      );
                                    } else if (status == '1/4') {
                                      return Container(
                                        margin: const EdgeInsets.all(4.0),
                                        decoration: const BoxDecoration(
                                          color: Colors.orange,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${day.day}',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      );
                                    } else if (status == '3/4') {
                                      return Container(
                                        margin: const EdgeInsets.all(4.0),
                                        decoration: const BoxDecoration(
                                          color: Colors.lightGreen,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${day.day}',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      );
                                    }

                                    return null;
                                  },
                                  selectedBuilder: (context, day, focusedDay) {
                                    return Container(
                                      margin: const EdgeInsets.all(4.0),
                                      decoration: const BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${day.day}',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: viewModel.isdataavailable
                                    ? Column(
                                        // crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            height: 50,
                                          ),
                                          Text(
                                            'Total Working Days: $totalDays',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              const SizedBox(
                                                width: 118,
                                              ),
                                              const CircleAvatar(
                                                backgroundColor: Colors.green,
                                                maxRadius: 5,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                'Full days: $presentCount',
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const SizedBox(
                                                width: 118,
                                              ),
                                              const CircleAvatar(
                                                backgroundColor:
                                                    Colors.lightGreen,
                                                maxRadius: 5,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                '3/4: $threequarter',
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const SizedBox(
                                                width: 118,
                                              ),
                                              const CircleAvatar(
                                                backgroundColor: Colors.grey,
                                                maxRadius: 5,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                'half days: $halfday',
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const SizedBox(
                                                width: 118,
                                              ),
                                              const CircleAvatar(
                                                backgroundColor: Colors.orange,
                                                maxRadius: 5,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                '1/4: $quarter',
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const SizedBox(
                                                width: 118,
                                              ),
                                              const CircleAvatar(
                                                backgroundColor: Colors.red,
                                                maxRadius: 5,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                'leaves: $leaveCount',
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    : const Center(
                                        child: Text('No Data Available'),
                                      ),
                              ),
                            ],
                          ),
                        ),
                ))
              ])
            ]));
      },
    );
  }
}
