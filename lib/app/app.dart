import 'package:flutter/material.dart';
import 'package:photo_gallary/app/constants/strings.dart';
import 'package:photo_gallary/app/routes/router.dart';
import 'core/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme();
    return MaterialApp.router(
      title: AppStrings.title,
      routerConfig: router,
      theme: theme.light(),
    );
  }
}