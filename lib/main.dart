import 'package:flutter/material.dart';
import 'src/di/dependencies_injection.dart' as di;
import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();        // ← register everything
  runApp(const App());

}