import 'package:flutter/material.dart';

import 'nav_button.dart';

class NavigateBar extends Container {
  final NavigationOptions activeOption;
  final Function goTo;

  NavigateBar({super.key, required this.activeOption, required this.goTo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      color: Colors.blue.shade900,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      child: SingleChildScrollView(
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
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
