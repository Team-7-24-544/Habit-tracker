import 'package:flutter/material.dart';
import '../widgets/navigate_bar.dart';

class TemplatePage extends StatelessWidget {
  final String title = 'Empty Page';

  const TemplatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Row(
          children: [
            // Left navigation column
            NavigateBar(),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                // ! here is main area !
              ),
            ),
          ],
        ),
      ),
    );
  }
}
