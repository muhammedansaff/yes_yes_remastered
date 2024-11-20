// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i10;
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i11;
import 'package:yes_yes/ui/views/forgotpassword/forgotpassword.dart' as _i7;
import 'package:yes_yes/ui/views/home/bottomnav/BottomNav.dart' as _i6;
import 'package:yes_yes/ui/views/home/screens/Homescreen/calender.dart' as _i9;
import 'package:yes_yes/ui/views/home/screens/Homescreen/Homescreen.dart'
    as _i8;
import 'package:yes_yes/ui/views/login/login.dart' as _i4;
import 'package:yes_yes/ui/views/signup/signin.dart' as _i5;
import 'package:yes_yes/ui/views/splash1/splash1.dart' as _i2;
import 'package:yes_yes/ui/views/splash2/splash_2.dart' as _i3;

class Routes {
  static const splash1 = '/Splash1';

  static const splash2 = '/Splash2';

  static const loginScreen = '/login-screen';

  static const signupScreen = '/signup-screen';

  static const botoomNav = '/botoom-nav';

  static const forgotpasswordscreen = '/Forgotpasswordscreen';

  static const homescreen = '/Homescreen';

  static const attendanceCalendar = '/attendance-calendar';

  static const all = <String>{
    splash1,
    splash2,
    loginScreen,
    signupScreen,
    botoomNav,
    forgotpasswordscreen,
    homescreen,
    attendanceCalendar,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.splash1,
      page: _i2.Splash1,
    ),
    _i1.RouteDef(
      Routes.splash2,
      page: _i3.Splash2,
    ),
    _i1.RouteDef(
      Routes.loginScreen,
      page: _i4.LoginScreen,
    ),
    _i1.RouteDef(
      Routes.signupScreen,
      page: _i5.SignupScreen,
    ),
    _i1.RouteDef(
      Routes.botoomNav,
      page: _i6.BotoomNav,
    ),
    _i1.RouteDef(
      Routes.forgotpasswordscreen,
      page: _i7.Forgotpasswordscreen,
    ),
    _i1.RouteDef(
      Routes.homescreen,
      page: _i8.Homescreen,
    ),
    _i1.RouteDef(
      Routes.attendanceCalendar,
      page: _i9.AttendanceCalendar,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.Splash1: (data) {
      return _i10.MaterialPageRoute<dynamic>(
        builder: (context) => const _i2.Splash1(),
        settings: data,
      );
    },
    _i3.Splash2: (data) {
      return _i10.MaterialPageRoute<dynamic>(
        builder: (context) => const _i3.Splash2(),
        settings: data,
      );
    },
    _i4.LoginScreen: (data) {
      return _i10.MaterialPageRoute<dynamic>(
        builder: (context) => const _i4.LoginScreen(),
        settings: data,
      );
    },
    _i5.SignupScreen: (data) {
      return _i10.MaterialPageRoute<dynamic>(
        builder: (context) => const _i5.SignupScreen(),
        settings: data,
      );
    },
    _i6.BotoomNav: (data) {
      return _i10.MaterialPageRoute<dynamic>(
        builder: (context) => const _i6.BotoomNav(),
        settings: data,
      );
    },
    _i7.Forgotpasswordscreen: (data) {
      return _i10.MaterialPageRoute<dynamic>(
        builder: (context) => const _i7.Forgotpasswordscreen(),
        settings: data,
      );
    },
    _i8.Homescreen: (data) {
      return _i10.MaterialPageRoute<dynamic>(
        builder: (context) => const _i8.Homescreen(),
        settings: data,
      );
    },
    _i9.AttendanceCalendar: (data) {
      return _i10.MaterialPageRoute<dynamic>(
        builder: (context) =>  _i9.AttendanceCalendar(),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

extension NavigatorStateExtension on _i11.NavigationService {
  Future<dynamic> navigateToSplash1([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.splash1,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSplash2([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.splash2,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToLoginScreen([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.loginScreen,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSignupScreen([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.signupScreen,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToBotoomNav([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.botoomNav,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToForgotpasswordscreen([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.forgotpasswordscreen,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToHomescreen([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.homescreen,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAttendanceCalendar([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.attendanceCalendar,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSplash1([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.splash1,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSplash2([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.splash2,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithLoginScreen([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.loginScreen,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSignupScreen([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.signupScreen,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithBotoomNav([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.botoomNav,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithForgotpasswordscreen([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.forgotpasswordscreen,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithHomescreen([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.homescreen,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAttendanceCalendar([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.attendanceCalendar,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
