import 'package:flutter/material.dart';
import 'package:website/models/MetaInfo.dart';
import 'package:website/services/api_manager.dart';
import 'pages/registration_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';

void main() {
  final metaInfo = MetaInfo.instance;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final apiManager = ApiManager();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //check(apiManager);
    return MaterialApp(
      title: 'Flutter Demo', //toDo: change name and icon
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/debug',
      routes: {
        '/login': (context) => LoginPage(apiManager: apiManager),
        '/registration': (context) => RegistrationPage(apiManager, context),
        '/home': (context) => HomePage(apiManager),
        '/debug': (context) => HomePage(apiManager),
      },
    );
  }
}
