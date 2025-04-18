import 'package:flutter/material.dart';
import 'package:photo_gallary/app/routes/router.dart';
import 'core/theme/text_theme.dart';
import 'core/theme/theme.dart';
import 'core/theme/theme_provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    final themeProvider = ThemeProvider();

    AppTheme theme = AppTheme();
    return MaterialApp.router(
      title: 'Photo Gallery',
      routerConfig: router,
      theme: theme.light(),
      darkTheme: theme.light(),
      themeMode:themeProvider.themeMode,
    );
  }
}