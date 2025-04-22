import 'package:flutter/material.dart';
import 'package:website/pages/about_page.dart';

import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/registration_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo', //toDo: change name and icon
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/entry',
      routes: {
        '/login': (context) => LoginPage(),
        '/registration': (context) => RegistrationPage(context),
        '/home': (context) => HomePage(),
        '/entry': (context) => LoginPage(),
        '/about': (context) => AboutPage(),
      },
    );
  }
}
