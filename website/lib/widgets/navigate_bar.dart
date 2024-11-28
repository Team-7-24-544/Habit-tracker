import 'package:flutter/material.dart';
import '../widgets/nav_button.dart';

class NavigateBar extends Container {
  final NavigationOptions activeOption;
  final Function goTo;

  NavigateBar({super.key, required this.activeOption, required this.goTo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      color: Colors.blue.shade900,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          createNavButton(NavigationOptions.home, activeOption, goTo),
          createNavButton(NavigationOptions.habits, activeOption, goTo),
          createNavButton(NavigationOptions.newHabit, activeOption, goTo),
          createNavButton(NavigationOptions.groups, activeOption, goTo),
          createNavButton(NavigationOptions.achievements, activeOption, goTo),
          createNavButton(NavigationOptions.profile, activeOption, goTo),
          createNavButton(NavigationOptions.settings, activeOption, goTo),
        ],
      ),
    );
  }
}
