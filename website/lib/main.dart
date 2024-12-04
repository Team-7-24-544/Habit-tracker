import 'package:flutter/material.dart';
import 'package:website/services/api_manager.dart';
import 'pages/registration_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final apiManager = ApiManager();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    check(apiManager);
    return MaterialApp(
      title: 'Flutter Demo', //toDo: change name and icon
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/home',
      routes: {
        '/login': (context) => const LoginPage(),
        '/registration': (context) => const RegistrationPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
