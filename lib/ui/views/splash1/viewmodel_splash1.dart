import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'dart:io';

// ignore: camel_case_types
class splash1_viewmodel extends BaseViewModel {
  // For Platform
  bool isWeb = kIsWeb;
  bool isMobile = !kIsWeb && (Platform.isIOS || Platform.isAndroid);

  bool isWebPlatform() {
    if (kIsWeb) {
      debugPrint('Running on the web');
    } else if (isMobile) {
      debugPrint('Running on a mobile platform');
    } else {
      debugPrint('Running on an unsupported platform');
    }

    return isWeb;
  }
}
