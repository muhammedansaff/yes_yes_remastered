import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yes_yes/constants/utils.dart';
import 'package:yes_yes/gen/assets.gen.dart';
import 'package:yes_yes/ui/refactored/button.dart';
import 'package:yes_yes/ui/views/splash2/viewmodel_splash2.dart';

class Splash2 extends StatelessWidget {
  const Splash2({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Splash2Viewmodel(),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: primaryColor,
          body: LayoutBuilder(
            builder: (context, constraints) {
              // Define a maximum width threshold for mobile screens
              const double mobileWidthThreshold = 500.0;

              // Check if the screen width is above the mobile threshold
              if (constraints.maxWidth > mobileWidthThreshold) {
                return const Center(
                  child: Text(
                    "This device is not compatible with this application.\n please reduce the width",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              // Continue with normal layout for mobile screens
              return Stack(
                children: [
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 200,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const SizedBox(
                              width: 22,
                            ),
                            Hero(
                              tag: "img",
                              child: SvgPicture.asset(
                                Assets.mainlogo,
                                width: constraints.maxWidth * 0.15,
                                height: constraints.maxHeight * 0.15,
                              ),
                            ),
                            const SizedBox(width: 22),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Hero(
                      tag: "hello",
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          color: Colors.white,
                        ),
                        width: double.infinity,
                        height: constraints.maxHeight * 0.4,
                        child: Column(
                          children: [
                            SizedBox(
                              height: constraints.maxHeight * 0.02,
                            ),
                            const Material(
                              child: Text(
                                "HELLO!",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "ansaf",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: constraints.maxHeight * 0.05,
                            ),
                            Consumer<Splash2Viewmodel>(
                              builder: (BuildContext context,
                                  Splash2Viewmodel value, Widget? child) {
                                return Material(
                                  child: MyButton(
                                    texsize: 16,
                                    width: constraints.maxWidth * 0.7,
                                    height: constraints.maxHeight * 0.06,
                                    isoutline: true,
                                    onPressed: () {
                                      value.navigateToLogin(context);
                                    },
                                    text: "LOGIN",
                                    col: buttoncolor,
                                    textcolor: Colors.white,
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              height: constraints.maxHeight * 0.03,
                            ),
                            Consumer<Splash2Viewmodel>(
                              builder: (BuildContext context,
                                  Splash2Viewmodel value, Widget? child) {
                                return Material(
                                  child: MyButton(
                                    width: constraints.maxWidth * 0.7,
                                    height: constraints.maxHeight * 0.06,
                                    texsize: 16,
                                    onPressed: () {
                                      value.navigateToSignup(context);
                                    },
                                    text: "SIGN UP",
                                    col: Colors.white,
                                    textcolor: buttoncolor,
                                    isoutline: false,
                                    bordercolor: buttoncolor,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
