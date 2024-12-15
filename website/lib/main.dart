import 'package:flutter/material.dart';
import 'package:website/models/MetaInfo.dart';
import 'package:website/models/MetaKeys.dart';
import 'pages/registration_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';

void main() {
  final metaInfo = MetaInfo.instance;
  MetaInfo.instance.set(MetaKeys.userId, 7); // for debug
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //final apiManager = ApiManager();
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
        '/login': (context) => LoginPage(),
        '/registration': (context) => RegistrationPage(context),
        '/home': (context) => HomePage(),
        '/debug': (context) => HomePage(),
      },
    );
  }
}
