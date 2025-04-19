import 'dart:async';
import 'package:flutter/material.dart';
import 'package:photo_gallary/app/app.dart';
import 'app/core/utils/logger.dart';
import 'app/di/injection.dart';

void main() => runZonedGuarded(_runMyApp, _reportError);

Future<void> _runMyApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencyInjection();
  runApp(
      const App()
  );
}


void _reportError(Object error, StackTrace stackTrace) {
  Log.e("Error: $error");
}
