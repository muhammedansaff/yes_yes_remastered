import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';

import 'package:stacked_services/stacked_services.dart';
import 'package:statusbarz/statusbarz.dart';

import 'package:yes_yes/app/app.router.dart';
import 'package:yes_yes/firebase_options.dart';
import 'package:yes_yes/ui/views/home/screens/Homescreen/viewmodelhome.dart';
import 'package:yes_yes/ui/views/splash2/viewmodel_splash2.dart';

import 'package:yes_yes/userstate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Splash2Viewmodel()),
        // Other providers
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: (context, child) {
        return StatusbarzCapturer(
          child: MaterialApp(
            home: const UserState(),
            debugShowCheckedModeBanner: false,
            title: "attendence",
            navigatorKey: StackedService.navigatorKey,
            onGenerateRoute: StackedRouter().onGenerateRoute,
            navigatorObservers: [
              StackedService.routeObserver,
              Statusbarz.instance.observer,
              FlutterSmartDialog.observer
            ],
          ),
        );
      },
    );
  }
}
