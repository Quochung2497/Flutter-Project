import 'package:flutter/material.dart';
import 'features/account/view/create_account_screen.dart';
import 'features/account/view/login_screen.dart';
import '../../../constants/routes.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
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
        Widget page;

        switch(settings.name){
          case AppRoutes.register:
            page = const CreateAccountScreen();
            break;
          case AppRoutes.login:
            page = const LoginScreen();
            break;
          default:
            page = const LoginScreen();
        }

        return PageRouteBuilder(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, animation, __, child){
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          }
        );
      },
    );
  }
}
