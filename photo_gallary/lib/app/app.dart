import 'package:flutter/material.dart';
import 'package:photo_gallary/app/routes/router.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Photo Gallery',
      routerConfig: router,
    );
  }
}