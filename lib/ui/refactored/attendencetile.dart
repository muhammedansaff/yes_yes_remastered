import 'package:flutter/material.dart';

class Attendencetile extends StatelessWidget {
  final String textslot;
  final int checkboxType;
  final bool isTimePassed;
  final bool isAttendanceMarked;
  final bool? slot1;
  final bool? slot2;
  final bool? slot3;
  final bool? slot4;
  final void Function(bool?) onChanged;
  final Widget buttonwidget;

  const Attendencetile({
    super.key,
    required this.textslot,
    required this.checkboxType,
    required this.isTimePassed,
    required this.isAttendanceMarked,
    this.slot1,
    this.slot2,
    this.slot3,
    this.slot4,
    required this.onChanged,
    required this.buttonwidget,
  });

  @override
  Widget build(BuildContext context) {
    Widget checkboxWidget;

    // Determine which checkbox to display based on the passed integer
    switch (checkboxType) {
      case 1:
        checkboxWidget = Checkbox(
          value: slot1,
          onChanged: onChanged,
          activeColor: Colors.teal,
        );
        break;
      case 2:
        checkboxWidget = Checkbox(
          value: slot2,
          onChanged: onChanged,
          activeColor: Colors.teal,
        );
        break;
      case 3:
        checkboxWidget = Checkbox(
          value: slot3,
          onChanged: onChanged,
          activeColor: Colors.teal,
        );
        break;
      case 4:
        checkboxWidget = Checkbox(
          value: slot4,
          onChanged: onChanged,
          activeColor: Colors.teal,
        );
        break;
      default:
        checkboxWidget = const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade300,
            Colors.grey.shade500,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            spreadRadius: 1,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isAttendanceMarked
                    ? Icons.check_circle
                    : isTimePassed
                        ? Icons.cancel
                        : Icons.access_time,
                color: isAttendanceMarked
                    ? Colors.green
                    : isTimePassed
                        ? Colors.red
                        : Colors.grey.shade700,
                size: 28,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  textslot,
                  style: TextStyle(
                    color: isAttendanceMarked
                        ? Colors.green.shade700
                        : Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (!isTimePassed && !isAttendanceMarked) ...[
                checkboxWidget,
                buttonwidget,
              ]
            ],
          ),
          const SizedBox(height: 8),
          // Display messages based on conditions
          if (isAttendanceMarked)
            const Text(
              'Attendance marked',
              style: TextStyle(
                color: Colors.green,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            )
          else if (isTimePassed)
            const Text(
              'Time passed',
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }
}
