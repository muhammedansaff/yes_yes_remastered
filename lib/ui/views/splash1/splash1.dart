import 'package:flutter/material.dart';

import 'package:stacked_services/stacked_services.dart';
import 'package:yes_yes/app/app.router.dart';
import 'package:yes_yes/constants/utils.dart';

import 'package:yes_yes/ui/refactored/button.dart';

class Splash1 extends StatelessWidget {
  const Splash1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          const double mobileWidthThreshold = 500.0;

          if (constraints.maxWidth > mobileWidthThreshold) {
            return const Center(
              child: Text(
                "This device is not compatible with this application.\nPlease reduce the width.",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }

          return Stack(
            children: [
              // Center(
              //   child: SvgPicture.asset(
              //     Assets.logoo,
              //     width: constraints.maxWidth * 0.15,
              //     height: constraints.maxHeight * 0.15,
              //   ),
              // ),
              Positioned(
                bottom: constraints.maxHeight * 0.1,
                left: constraints.maxWidth * 0.15,
                right: constraints.maxWidth * 0.15,
                child: MyButton(
                  col: buttoncolor,
                  width: constraints.maxWidth * 0.7,
                  height: constraints.maxHeight * 0.06,
                  texsize: 16,
                  isoutline: true,
                  textcolor: Colors.white,
                  onPressed: () {
                    NavigationService().replaceWith(Routes.splash2);
                  },
                  text: "GET STARTED",
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
