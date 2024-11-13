import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'task_list_screen.dart';
import 'login_screen.dart';
import 'firebase_auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AuthService().isSignedIn() ? TaskListScreen() : LoginScreen(),
    );
  }
}