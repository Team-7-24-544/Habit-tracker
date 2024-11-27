import 'package:flutter/material.dart';
import '../widgets/nav_button.dart';

class NavigateBar extends Container {
  NavigateBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      color: Colors.blue.shade900,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          createNavButton(NavigationOptions.home),
          createNavButton(NavigationOptions.habits),
          createNavButton(NavigationOptions.newHabit),
          createNavButton(NavigationOptions.groups),
          createNavButton(NavigationOptions.achievements),
          createNavButton(NavigationOptions.profile),
          createNavButton(NavigationOptions.settings),
        ],
      ),
    );
  }
}
