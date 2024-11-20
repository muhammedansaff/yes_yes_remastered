import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yes_yes/ui/views/forgotpassword/forgotpassword.dart';
import 'package:yes_yes/ui/views/home/bottomnav/BottomNav.dart';
import 'package:yes_yes/ui/views/home/screens/Homescreen/Homescreen.dart';
import 'package:yes_yes/ui/views/home/screens/Homescreen/calender.dart';


import 'package:yes_yes/ui/views/splash1/splash1.dart';

import 'package:yes_yes/ui/views/splash2/splash_2.dart';
import 'package:yes_yes/ui/views/login/login.dart';
import 'package:yes_yes/ui/views/signup/signin.dart';

import '../services/example_service.dart';

@StackedApp(
  routes: [
    MaterialRoute(
      page: Splash1,
    ),
    MaterialRoute(page: Splash2),
    MaterialRoute(page: LoginScreen),
    MaterialRoute(page: SignupScreen),
    MaterialRoute(page: BotoomNav),
    MaterialRoute(page: Forgotpasswordscreen),
    MaterialRoute(page: Homescreen),
    MaterialRoute(page: AttendanceCalendar),
  ],
  dependencies: [
    Singleton(classType: NavigationService),
    LazySingleton(classType: ExampleService),
  ],
)
class App {}
