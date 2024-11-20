import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yes_yes/ui/views/home/screens/Homescreen/Homescreen.dart';
import 'package:yes_yes/ui/views/home/screens/Leavescreen/Leavescreen.dart';
import 'package:yes_yes/ui/views/home/screens/payrollscreen/payroll.dart';
import 'package:yes_yes/ui/views/home/screens/profie/profilescreen.dart';

class BottomNavViewModel extends BaseViewModel {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  Widget getCurrentScreen() {
    switch (_currentIndex) {
      case 2:
        return const PayrollScreen();
      case 3:
        return const Profilescreen();
      case 1:
        return const Leavescreen();
      default:
        return const Homescreen();
    }
  }
}
