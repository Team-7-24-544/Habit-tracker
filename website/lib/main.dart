import 'package:flutter/material.dart';
import 'package:website/models/MetaInfo.dart';
import 'package:website/models/MetaKeys.dart';
import 'package:website/pages/profile_page.dart';
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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //check(apiManager);
    return MaterialApp(
      title: 'Flutter Demo', //toDo: change name and icon
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => ProfilePage(),
        '/registration': (context) => RegistrationPage(context),
        '/home': (context) => HomePage(),
        '/debug': (context) => HomePage(),
      },
    );
  }
}
