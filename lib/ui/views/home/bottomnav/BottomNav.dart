import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:yes_yes/constants/utils.dart';
import 'package:yes_yes/ui/views/home/bottomnav/viewmodelbottom.dart';

class BotoomNav extends StatelessWidget {
  const BotoomNav({super.key});

  @override
  Widget build(BuildContext context) {
    
    final screenWidth = MediaQuery.of(context).size.width;

    return ViewModelBuilder<BottomNavViewModel>.reactive(
      viewModelBuilder: () => BottomNavViewModel(),
      builder: (context, model, child) => Scaffold(
          extendBody: true,
          bottomNavigationBar: SizedBox(
            height: 105,
            child: FloatingNavbar(
              backgroundColor: primaryColor,
              iconSize: 25,
              onTap: (int index) {
                model.setIndex(index);
              },
              width: screenWidth * 0.89,
              currentIndex: model.currentIndex,
              items: [
                FloatingNavbarItem(icon: Icons.edit_calendar, title: 'Home'),
                  FloatingNavbarItem(icon: Icons.accessible_rounded, title: 'leave'),
                FloatingNavbarItem(icon: Icons.attach_money, title: 'Payroll'),
                FloatingNavbarItem(icon: Icons.person, title: 'Profile'),
              ],
            ),
          ),
          backgroundColor: primaryColor,
          drawer: const Drawer(
            backgroundColor: Colors.white,
          ),
          body: model.getCurrentScreen()),
    );
  }
}
