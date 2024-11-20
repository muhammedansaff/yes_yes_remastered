import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yes_yes/ui/views/home/bottomnav/BottomNav.dart';
import 'package:yes_yes/ui/views/login/login.dart';

import 'package:yes_yes/ui/views/splash2/splash_2.dart';

class UserState extends StatelessWidget {
  const UserState({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, userSnapshot) {
        if (userSnapshot.data == null) {
          print('user is not logged in yet');
          return const Splash2();
        } else if (userSnapshot.hasData) {
          print('user is already logged in yet');
          return const BotoomNav();
        } else if (userSnapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('An error has been occured ,Try again later'),
            ),
          );
        } else if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return const Scaffold(
          body: Center(child: Text('something went wrong ')),
        );
      },
    );
  }
}
