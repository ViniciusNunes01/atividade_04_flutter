import 'package:atividade_login/forgot_password_page.dart';
import 'package:atividade_login/register_page.dart';
import 'package:flutter/material.dart';
import 'themes/theme_controller.dart';
import 'themes/light_theme.dart';
import 'themes/dark_theme.dart';
import 'splash_page.dart';
import 'onboarding_page.dart';
import 'login_page.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.notifier,
      builder: (context, mode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Auth App',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: mode,
          initialRoute: '/',
          routes: {
            '/':         (_) => const SplashPage(),
            '/onboarding': (_) => const OnboardingPage(),
            '/login':     (_) => const LoginPage(),
            '/register':  (_) => RegisterPage(),
            '/forgot':    (_) => ForgotPasswordPage(),
            '/home': (_) => const MyHomePage(title: 'App de notas'),
          },
        );
      },
    );
  }
}