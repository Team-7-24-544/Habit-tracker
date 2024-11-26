import 'package:flutter/material.dart';

class AuthorizationPage extends StatefulWidget {
  const AuthorizationPage({super.key, required this.title});
  final String title;

  @override
  State<AuthorizationPage> createState() => _AuthorizationState();
}

class _AuthorizationState extends State<AuthorizationPage> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme
      //       .of(context)
      //       .colorScheme
      //       .inversePrimary,
      //   title: Text(widget.title),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Hello, world!',
            ),
          ],
        ),
      ),
    );
  }
}