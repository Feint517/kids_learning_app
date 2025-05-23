import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kids_learning_app/app.dart';
import 'package:flutter/foundation.dart';

void main() async {
  //* Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  //* Set preferred orientations
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize GetStorage
  await GetStorage.init();

  // Run the app
  runApp(DevicePreview(enabled: kDebugMode, builder: (context) => App())); 
}
