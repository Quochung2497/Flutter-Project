import 'package:flutter/material.dart';
import 'package:example_app/src/constants/routes.dart';
import 'package:example_app/src/features/auth/ui/screen/login_screen.dart';
import 'package:example_app/src/features/auth/ui/screen/create_account_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example Flutter App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.login,
      onGenerateRoute: (settings) {
        late final Widget page;
        switch (settings.name) {
          case AppRoutes.register:
            page = const CreateAccountScreen();
            break;
          case AppRoutes.login:
          default:
            page = const LoginScreen();
        }
        return PageRouteBuilder(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }
}