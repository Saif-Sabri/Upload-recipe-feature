import 'package:demo/core/router/router.dart';
import 'package:demo/core/theme/dark_theme.dart';
import 'package:demo/core/theme/light_theme.dart';
import 'package:flutter/material.dart';

import 'core/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(
    const MainApp(),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Recipe uploader demo ',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      themeMode: ThemeMode.system,
      theme: LightTheme.theme,
      darkTheme: DarkTheme.theme,
    );
  }
}
