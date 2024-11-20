import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yes_yes/ui/views/login/login.dart';
import 'package:yes_yes/ui/views/signup/signin.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'dart:io';

class Splash2Viewmodel extends BaseViewModel {
  void navigateToLogin(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionDuration: const Duration(seconds: 2),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  bool isWeb = kIsWeb;
  bool isMobile = !kIsWeb && (Platform.isIOS || Platform.isAndroid);
  bool isWebPlatform() {
    if (isWeb) {
      debugPrint('Running on the web');
    } else if (isMobile) {
      debugPrint('Running on a mobile platform');
    } else {
      debugPrint('Running on an unsupported platform');
    }

    return isWeb;
  }

  void navigateToSignup(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SignupScreen(),
        transitionDuration: const Duration(seconds: 2),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }
}
