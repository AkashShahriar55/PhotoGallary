import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photo_gallary/app/app.dart';




void main() => runZonedGuarded(_runMyApp, _reportError);

Future<void> _runMyApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}


void _reportError(Object error, StackTrace stackTrace) {

}
